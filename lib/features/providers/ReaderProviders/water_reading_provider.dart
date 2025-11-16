import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/api.dart';
import '../../database/database_helper.dart';
import 'storage_provider.dart';

class WaterReadingProvider extends ChangeNotifier {
  final readingController = TextEditingController();
  final notesController = TextEditingController();
  File? meterPhoto;

  bool isSaving = false;

  void initializeReading(String value) {
    readingController.text = value;
  }

  /// Initialize the reading controller with the latest local reading for the meter if present.
  /// Prefers the most recent reading saved locally (unsynced or synced).
  Future<void> initializeReadingForMeter(String meterNumber) async {
    try {
      final db = DatabaseHelper();
      final latest = await db.getLatestReadingForMeter(meterNumber);
      // latest comes from `water_readings` table; use the `reading` column
      if (latest != null && latest['reading'] != null) {
        readingController.text = latest['reading'].toString();
      } else {
        readingController.clear();
      }
    } catch (e) {
      // If DB fails, fallback to empty
      readingController.clear();
    }
    notifyListeners();
  }

  void pickPhoto() {
    // implement photo picker logic
    notifyListeners();
  }

  // --------------------------------------------------
  // UNIFIED SAVE READING FLOW
  // --------------------------------------------------
  // Saves locally
  Future<void> saveReading(
    BuildContext context, {
    required String meterNumber,
    required String readerCode,
  }) async {
    if (readingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the reading")),
      );
      return;
    }

    isSaving = true;
    notifyListeners();

    try {

      await _saveLocally(
        meterNumber: meterNumber,
        readerCode: readerCode,
      );

      // Refresh storage stats so offline counters update immediately
      try {
        final storage = Provider.of<StorageProvider>(context, listen: false);
        await storage.refreshStats();
      } catch (_) {
        // ignore if storage provider not available
      }

      _clearInputs();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------
  // (1) SAVE LOCALLY - Save to water_readings table
  // --------------------------------------------------
  Future<void> _saveLocally({
    required String meterNumber,
    required String readerCode,
  }) async {
    final db = DatabaseHelper();

    final entry = {
      "meterNumber": meterNumber,
      "readerCode": readerCode,
      "reading": readingController.text,
      "notes": notesController.text,
      "img": meterPhoto != null ? meterPhoto!.readAsBytesSync() : null,
      "timestamp": DateTime.now().toIso8601String(),
      "synced": 0, // Mark as unsynced
    };

    await db.insertWaterReading(entry);

    // Update the assigned_areas table to mark this meter as completed
    try {
      await db.markAreaCompleted(meterNumber, lastReading: readingController.text);
    } catch (e) {
      // Don't fail the save flow if updating the assigned area fails.
      print('Could not update assigned area status: $e');
    }
  }


  // --------------------------------------------------
  // CLEAR INPUTS
  // --------------------------------------------------
  void _clearInputs() {
    readingController.clear();
    notesController.clear();
    meterPhoto = null;
    notifyListeners();
  }

  // --------------------------------------------------
  // SYNC PENDING READINGS (called during Sync Now)
  // Returns true if all readings synced successfully, false if any failed
  // --------------------------------------------------
  Future<bool> syncPendingReadings({StorageProvider? storageProvider}) async {
    final db = DatabaseHelper();
    final pending = await db.getQueuedReadings(onlyUnsynced: true);

    // If no pending readings, consider it a successful sync
    if (pending.isEmpty) {
      print("✅ No pending readings to sync");
      return true;
    }

    final syncedIds = <int>[];
    bool anyFailed = false;

    for (final row in pending) {
      try {
        final payload = {
          "readerCode": row["readerCode"],
          "meterNumber": row["meterNumber"],
          "currentReading": row["reading"],
          "notes": row["notes"],
          "img": row["img"] != null ? base64Encode(row["img"]) : null,
        };

        final response =
            await ApiService.post('/reader/reading/submit', payload);
        final data = jsonDecode(response.body);

        if (response.statusCode == 200 && data["success"] == true) {
          // Mark for sync after successful upload
          syncedIds.add(row["id"]);
        } else {
          anyFailed = true;
          print("❌ Reading sync failed: ${data["message"]}");
          break;
        }
      } catch (e) {
        // If any fail, stop sync so it's safe
        anyFailed = true;
        print("❌ Reading sync error: $e");
        break;
      }
    }

    // Update all successfully synced readings
    if (syncedIds.isNotEmpty) {
      await db.markReadingsAsSynced(syncedIds);
      print("✅ ${syncedIds.length} readings synced");
      // Refresh storage stats if provider passed
      try {
        if (storageProvider != null) {
          await storageProvider.refreshStats();
          storageProvider.markSynced();
        }
      } catch (e) {
        // ignore errors from storage provider
      }
    }

    // Return true only if all pending readings were synced
    return !anyFailed && syncedIds.length == pending.length;
  }
}

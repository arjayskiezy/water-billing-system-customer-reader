import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/api.dart';
import '../../database/database_helper.dart';
import 'settings_profile.dart';

class WaterReadingProvider extends ChangeNotifier {
  // ----------------- Controllers -----------------
  final TextEditingController readingController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  File? meterPhoto;
  bool isSaving = false;

  // ----------------- Initialize -----------------
  void initializeReading(String value) {
    readingController.text = value;
  }

  /// Load latest reading for a meter from local DB (unsynced or synced)
  Future<void> initializeReadingForMeter(String meterNumber) async {
    try {
      final db = DatabaseHelper();
      final latest = await db.getLatestReadingForMeter(meterNumber);

      if (latest != null && latest['reading'] != null) {
        readingController.text = latest['reading'].toString();
      } else {
        readingController.clear();
      }
    } catch (_) {
      readingController.clear();
    }
    notifyListeners();
  }

  // ----------------- Pick Photo -----------------
  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024, // compress to reduce Base64 size
      maxHeight: 1024,
      imageQuality: 70,
    );

    if (picked != null) {
      meterPhoto = File(picked.path);
      notifyListeners();
    }
  }

  // ----------------- Save Reading -----------------
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
      await _saveLocally(meterNumber: meterNumber, readerCode: readerCode);

      // Refresh storage stats
      try {
        final storage = Provider.of<StorageProvider>(context, listen: false);
        await storage.refreshStats();
      } catch (_) {}

      _clearInputs();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving reading: $e")),
      );
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // ----------------- Private Local Save -----------------
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
      "img": meterPhoto != null ? await meterPhoto!.readAsBytes() : null,
      "timestamp": DateTime.now().toIso8601String(),
      "synced": 0,
    };

    await db.insertWaterReading(entry);

    // Mark assigned area as completed
    try {
      await db.markAreaCompleted(
        meterNumber,
        lastReading: readingController.text,
      );
    } catch (e) {
      print('Could not update assigned area: $e');
    }
  }

  // ----------------- Clear Inputs -----------------
  void _clearInputs() {
    readingController.clear();
    notesController.clear();
    meterPhoto = null;
    notifyListeners();
  }

  // ----------------- Sync Pending Readings -----------------
  /// Returns true if all readings synced successfully.
  /// If some failed, returns false and prints failures.
  Future<bool> syncPendingReadings({StorageProvider? storageProvider}) async {
    final db = DatabaseHelper();
    final pending = await db.getQueuedReadings(onlyUnsynced: true);

    if (pending.isEmpty) {
      print("✅ No pending readings to sync");
      return true;
    }

    final syncedIds = <int>[];
    final failedReadings = <Map<String, dynamic>>[];

    for (final row in pending) {
      try {
        final payload = {
          "readerCode": row["readerCode"],
          "meterNumber": row["meterNumber"],
          "currentReading": row["reading"],
          "notes": row["notes"],
          "img": row["img"] != null
              ? base64Encode(row["img"] as Uint8List)
              : null,
        };

        final response = await ApiService.post(
          '/reader/reading/submit',
          payload,
        );
        final data = response.data;

        if (response.statusCode == 200 && data["success"] == true) {
          syncedIds.add(row["id"] as int);
        } else {
          failedReadings.add(row);
          print("❌ Sync failed for meter ${row["meterNumber"]}: ${data["message"]}");
        }
      } catch (e) {
        failedReadings.add(row);
        print("❌ Sync error for meter ${row["meterNumber"]}: $e");
      }
    }

    if (syncedIds.isNotEmpty) {
      await db.markReadingsAsSynced(syncedIds);
      print("✅ ${syncedIds.length} readings synced");
      try {
        if (storageProvider != null) {
          await storageProvider.refreshStats();
          storageProvider.markSynced();
        }
      } catch (_) {}
    }

    if (failedReadings.isNotEmpty) {
      print("⚠️ ${failedReadings.length} readings failed to sync");
      return false;
    }

    return true;
  }

  // ----------------- Dispose -----------------
  @override
  void dispose() {
    readingController.dispose();
    notesController.dispose();
    super.dispose();
  }
}

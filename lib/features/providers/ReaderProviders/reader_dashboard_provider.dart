import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import 'input_readings_provider.dart';
import 'settings_profile.dart';

class ReaderDashboardProvider extends ChangeNotifier {
  int assigned = 0;
  int completed = 0;
  int remaining = 0;

  bool isOnline = true; 
  String syncStatus = "Not synced yet";

  bool isLoading = false;

  double get completionRate {
    if (assigned == 0) return 0.0;
    return completed / assigned;
  }

  // 🔵 Load stats from the local SQLite database
  Future<void> loadDashboardStats() async {
    isLoading = true;
    notifyListeners();

    try {
      final db = DatabaseHelper();

      // Load assigned areas
      final assignedAreas = await db.getAssignedAreas();
      assigned = assignedAreas.length;

      // Count completed by checking status field
      // Status is set to 'Completed' when a reading is saved for that meter
      completed = assignedAreas.where((item) {
        final status = item["status"];
        return status != null && status.toString().trim().toUpperCase() == "COMPLETED";
      }).length;

      // Compute remaining
      remaining = assigned - completed;

      print("📊 Dashboard stats: assigned=$assigned, completed=$completed, remaining=$remaining");

      syncStatus = "Using Local Data";
    } catch (e) {
      syncStatus = "Error loading data";
      print("Dashboard load error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // 🔵 Called when user taps "Sync Now"
  Future<void> syncNow(
    WaterReadingProvider waterReadingProvider, {
    StorageProvider? storageProvider,
    required int readerId,
  }) async {
    syncStatus = "Syncing...";
    notifyListeners();

    try {
      // Step 1: Sync pending readings first (returns success flag)
      final readingsSynced =
          await waterReadingProvider.syncPendingReadings(storageProvider: storageProvider);

      await loadDashboardStats();

      // Set status based on both results
      if (readingsSynced ) {
        syncStatus = "Synced successfully";
      }

    } catch (e) {
      syncStatus = "Sync failed";
      print("Sync error: $e");
    }

    notifyListeners();
  }

  // 🔵 Replaces your old refreshMockData()
  Future<void> refreshDashboard(int readerId) async {
    syncStatus = "Refreshing...";
    notifyListeners();

    // Always reload local stats after attempting refresh
    await loadDashboardStats();

    notifyListeners();
  }

  // Optional: Set online/offline status
  void setOnline(bool value) {
    isOnline = value;
    notifyListeners();
  }
}

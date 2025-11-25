import 'package:flutter/material.dart';
import '../../database/database_helper.dart';

class StorageProvider extends ChangeNotifier {
  double _storageUsed = 0.0; // in MB
  int _offlineReadings = 0;
  DateTime _lastSync = DateTime.now().subtract(const Duration(days: 365));

  StorageProvider() {
    // Initialize dynamic values from local DB
    refreshStats();
  }

  // Getters
  double get storageUsed => _storageUsed;
  int get offlineReadings => _offlineReadings;
  String get lastSyncFormatted {
    final duration = DateTime.now().difference(_lastSync);
    if (duration.inMinutes < 1) return "Just now";
    if (duration.inMinutes < 60) return "${duration.inMinutes} minutes ago";
    if (duration.inHours < 24) return "${duration.inHours} hours ago";
    return "${duration.inDays} days ago";
  }

  // Methods
  void updateStorage(double newValue) {
    _storageUsed = newValue;
    notifyListeners();
  }

  void updateOfflineReadings(int newValue) {
    _offlineReadings = newValue;
    notifyListeners();
  }

  void markSynced() {
    _lastSync = DateTime.now();
    
    // When marking synced, refresh counts/storage
    refreshStats();
    notifyListeners();
  }

  Future<void> clearLocalData() async {
    await DatabaseHelper().clearAllData();
    _offlineReadings = 0;
    _storageUsed = 0.0;
    _lastSync = DateTime.now();
    notifyListeners();
  }

  /// Refresh dynamic stats from local database (unsynced readings and storage)
  Future<void> refreshStats() async {
    try {
      final db = DatabaseHelper();
      final pending = await db.getQueuedReadings(onlyUnsynced: true);

      // Count pending readings
      _offlineReadings = pending.length;

      // Approximate storage used by summing image blob sizes + small estimate for text fields
      int totalBytes = 0;
      for (final row in pending) {
        final img = row['img'];
        if (img is List<int>) {
          totalBytes += img.length;
        }

        // rough estimate for other fields per reading
        final readingStr = row['reading']?.toString() ?? '';
        final notesStr = row['notes']?.toString() ?? '';
        totalBytes += (readingStr.length + notesStr.length) * 2; // approx 2 bytes/char
      }

      // Convert to megabytes with one decimal
      _storageUsed = double.parse((totalBytes / (1024 * 1024)).toStringAsFixed(1));
      notifyListeners();
    } catch (e) {
      // On error, keep previous values but log for debugging
      debugPrint('StorageProvider.refreshStats error: $e');
    }
  }
}

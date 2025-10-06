import 'package:flutter/material.dart';

class StorageProvider extends ChangeNotifier {
  double _storageUsed = 45.2; // in MB
  int _offlineReadings = 3;
  DateTime _lastSync = DateTime.now().subtract(const Duration(minutes: 2));

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
    notifyListeners();
  }

  void clearLocalData() {
    _offlineReadings = 0;
    _storageUsed = 0.0;
    notifyListeners();
  }
}

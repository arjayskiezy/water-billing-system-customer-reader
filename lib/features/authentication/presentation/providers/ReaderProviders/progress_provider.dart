import 'package:flutter/foundation.dart';

class ReaderDashboardProvider extends ChangeNotifier {
  // Initial mock data
  int _remaining = 5;
  int _completed = 10;
  int _assigned = 15;
  bool _isOnline = true;
  bool _isSynced = false; // false = unsynced, true = synced

  // Getters
  int get remaining => _remaining;
  int get completed => _completed;
  int get assigned => _assigned;
  double get completionRate => _completed / _assigned;
  bool get isOnline => _isOnline;
  String get syncStatus =>
      _isSynced ? "All readings synced" : "Readings unsynced";

  // Toggle between synced and unsynced states
  void refreshMockData() {
    _isSynced = !_isSynced;

    if (_isSynced) {
      _completed = _assigned;
      _remaining = 0;
    } else {
      _completed = 13;
      _remaining = _assigned - _completed;
    }

    notifyListeners();
  }

  // Update online status
  void setOnlineStatus(bool status) {
    _isOnline = status;
    notifyListeners();
  }
}

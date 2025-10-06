import 'package:flutter/foundation.dart';

class ReaderDashboardProvider extends ChangeNotifier {
  // Mock data
  int _remaining = 5;
  int _completed = 10;
  int _assigned = 15;
  double _completionRate = 0.7;
  String _syncStatus = "All readings synced"; // or "2 readings ready to sync"
  bool _isOnline = true;

  // Getters
  int get remaining => _remaining;
  int get completed => _completed;
  int get assigned => _assigned;
  double get completionRate => _completionRate;
  String get syncStatus => _syncStatus;
  bool get isOnline => _isOnline;

  // Methods to simulate data updates
  void refreshMockData() {
    // You can later replace this with actual API or DB fetch
    _remaining = 2;
    _completed = 13;
    _assigned = 15;
    _completionRate = _completed / _assigned;
    _syncStatus = "1 reading ready to sync";
    notifyListeners();
  }

  void setOnlineStatus(bool status) {
    _isOnline = status;
    notifyListeners();
  }
}

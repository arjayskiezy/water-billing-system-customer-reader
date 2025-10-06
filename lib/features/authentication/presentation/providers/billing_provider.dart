import 'package:flutter/material.dart';

class BillingProvider extends ChangeNotifier {
  double _currentAmountDue = 0.0;
  DateTime _dueDate = DateTime.now();
  double _lastMonthUsage = 0.0; // in m³

  double get currentAmountDue => _currentAmountDue;
  DateTime get dueDate => _dueDate;
  double get lastMonthUsage => _lastMonthUsage;

  void setBillingInfo(double amount, DateTime date, double usage) {
    _currentAmountDue = amount;
    _dueDate = date;
    _lastMonthUsage = usage;
    notifyListeners();
  }

  // Example: Fetch billing info from API or local storage
  Future<void> fetchBillingInfo(String accountNumber) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Example data
    setBillingInfo(2840.50, DateTime(2025, 9, 25), 452.325);
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillingHistoryProvider extends ChangeNotifier {
  // --------------------
  // Billing data
  // --------------------
  final List<Map<String, dynamic>> _billingData = [
    {
      'month': DateTime(2025, 8, 12),
      'dueDate': DateTime(2025, 9, 18),
      'amount': 2342.51,
      'usage': 300.127,
      'paid': false,
      'breakdown': {
        'Water Consumption': 1450.23,
        'Maintenance Fee': 50.00,
        'Taxes': 1.00,
        'Unpaid Bill': 4410.13,
      },
    },
    {
      'month': DateTime(2025, 7, 12),
      'dueDate': DateTime(2025, 8, 18),
      'amount': 1150.32,
      'usage': 311.732,
      'paid': false,
      'breakdown': {
        'Water Consumption': 980.00,
        'Maintenance Fee': 50.00,
        'Taxes': 0.32,
        'Unpaid Bill': 120.00,
      },
    },
    {
      'month': DateTime(2025, 6, 14),
      'dueDate': DateTime(2025, 7, 25),
      'amount': 11231.50,
      'usage': 4121.217,
      'paid': true,
      'breakdown': {
        'Water Consumption': 8900.00,
        'Maintenance Fee': 80.00,
        'Taxes': 21.50,
        'Unpaid Bill': 2230.00,
      },
    },
    {
      'month': DateTime(2025, 4, 14),
      'dueDate': DateTime(2025, 5, 31),
      'amount': 1123.21,
      'usage': 800.562,
      'paid': true,
      'breakdown': {
        'Water Consumption': 900.00,
        'Maintenance Fee': 50.00,
        'Taxes': 23.21,
        'Unpaid Bill': 150.00,
      },
    },
  ];

  String _filter = "All";

  // --------------------
  // Getters
  // --------------------
  String get filter => _filter;

  List<Map<String, dynamic>> get billingData {
    if (_filter == "Paid") {
      return _billingData.where((item) => item['paid'] == true).toList();
    } else if (_filter == "Unpaid") {
      return _billingData.where((item) => item['paid'] == false).toList();
    }
    return _billingData;
  }

  // --------------------
  // Setters
  // --------------------
  void setFilter(String newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  // --------------------
  // Format date
  // --------------------
  String formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date); // September 25, 2025
  }
}

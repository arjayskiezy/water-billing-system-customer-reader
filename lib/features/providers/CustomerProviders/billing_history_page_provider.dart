import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/api.dart';

class BillingHistory {
  final DateTime month;
  final DateTime dueDate;
  final double amount;
  final double usage;
  final bool paid;
  final Map<String, double> breakdown;

  BillingHistory({
    required this.month,
    required this.dueDate,
    required this.amount,
    required this.usage,
    required this.paid,
    required this.breakdown,
  });

  factory BillingHistory.fromJson(Map<String, dynamic> json) {
    return BillingHistory(
      month: DateTime.parse(json['month'] ?? DateTime.now().toString()),
      dueDate: DateTime.parse(json['dueDate'] ?? DateTime.now().toString()),
      amount: (json['amount'] ?? 0).toDouble(),
      usage: (json['usage'] ?? 0).toDouble(),
      paid: json['paid'] ?? false,
      breakdown: Map<String, double>.from(
        (json['breakdown'] as Map? ?? {}).map(
          (key, value) => MapEntry(key.toString(), (value ?? 0).toDouble()),
        ),
      ),
    );
  }
}

class BillingHistoryProvider extends ChangeNotifier {
  // ============== STATE VARIABLES ==============
  List<BillingHistory> _billingHistory = [];
  bool _isLoading = false;
  String _filter = "All";
  String? _error;

  // ============== GETTERS ==============
  bool get isLoading => _isLoading;
  String get filter => _filter;
  String? get error => _error;

  List<BillingHistory> get billingData {
    if (_filter == "Paid") {
      return _billingHistory.where((item) => item.paid == true).toList();
    } else if (_filter == "Unpaid") {
      return _billingHistory.where((item) => item.paid == false).toList();
    }
    return _billingHistory;
  }

  // Computed getters
  double get totalBilledAmount =>
      _billingHistory.fold(0.0, (sum, bill) => sum + bill.amount);

  double get totalUnpaid => _billingHistory
      .where((bill) => !bill.paid)
      .fold(0.0, (sum, bill) => sum + bill.amount);

  double get totalPaid => _billingHistory
      .where((bill) => bill.paid)
      .fold(0.0, (sum, bill) => sum + bill.amount);

  // ============== PUBLIC METHODS ==============
  /// Fetch billing history from API
  Future<void> fetchBillingHistory(String accountNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Fetching billing history for account: $accountNumber');

      final data = await ApiService.get(
        '/customer/billing-history/$accountNumber',
      );

      if (data != null) {
        if (data is List) {
          _billingHistory = data
              .map(
                (item) => BillingHistory.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        } else if (data is Map && data.containsKey('bills')) {
          _billingHistory = ((data['bills'] ?? []) as List)
              .map(
                (item) => BillingHistory.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }

        print('Loaded ${_billingHistory.length} billing records');
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('No billing history returned from service');
      }
    } catch (e) {
      _error = 'Failed to load billing history: $e';
      print('Error fetching billing history: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set filter for billing data
  void setFilter(String newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  /// Clear all billing data
  void reset() {
    _billingHistory = [];
    _filter = "All";
    _error = null;
    notifyListeners();
  }

  // ============== UTILITY METHODS ==============
  /// Format date to readable string
  String formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  /// Format currency value
  String formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '₱').format(amount);
  }

  /// Get status badge text
  String getStatusText(bool paid) {
    return paid ? 'Paid' : 'Unpaid';
  }

  /// Get billing summary for a specific month
  BillingHistory? getBillingByMonth(int month, int year) {
    try {
      return _billingHistory.firstWhere(
        (bill) => bill.month.month == month && bill.month.year == year,
      );
    } catch (e) {
      return null;
    }
  }
}

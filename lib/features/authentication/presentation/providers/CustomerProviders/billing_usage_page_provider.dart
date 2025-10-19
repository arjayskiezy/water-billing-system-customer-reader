import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../api/service.dart';

class BillBreakdownProvider extends ChangeNotifier {
  // --- Current Billing Info ---
  double currentAmountDue = 0.0;
  DateTime dueDate = DateTime.now();

  // --- Usage Details ---
  double previousReading = 0.0;
  double currentReading = 0.0;

  // --- Reading Dates ---
  DateTime previousReadingDate = DateTime.now();
  DateTime currentReadingDate = DateTime.now();

  // --- Billing Breakdown ---
  double waterConsumption = 0.0;
  double maintenanceFee = 0.0;
  double taxes = 0.0;
  double unpaidBill = 0.0;
  double totalPayment = 0.0;

  // --- Computed getters ---
  String get totalUsage {
    final usage = currentReading - previousReading;
    return usage.toStringAsFixed(3);
  }

  int get readingIntervalDays {
    return currentReadingDate.difference(previousReadingDate).inDays;
  }

  double get computedTotal =>
      waterConsumption + maintenanceFee + taxes + unpaidBill;

  // --- Fetch Data from API / Service ---
  Future<void> fetchBillBreakdown(String userId) async {
    try {
      print('Fetching bill for user: $userId'); // Debug start
      final data = await ApiService.get(
        '/bills/$userId',
      ); // Make sure userId is included

      print('Raw API response: $data'); // Debug raw JSON

      if (data != null) {
        // Map JSON fields to provider variables
        currentAmountDue = (data['currentAmountDue'] ?? 0).toDouble();
        dueDate = DateTime.parse(data['dueDate'] ?? DateTime.now().toString());

        previousReading = (data['previousReading'] ?? 0).toDouble();
        currentReading = (data['currentReading'] ?? 0).toDouble();

        previousReadingDate = DateTime.parse(
          data['previousReadingDate'] ?? DateTime.now().toString(),
        );
        currentReadingDate = DateTime.parse(
          data['currentReadingDate'] ?? DateTime.now().toString(),
        );

        waterConsumption = (data['waterConsumption'] ?? 0).toDouble();
        maintenanceFee = (data['maintenanceFee'] ?? 0).toDouble();
        taxes = (data['taxes'] ?? 0).toDouble();
        unpaidBill = (data['unpaidBill'] ?? 0).toDouble();
        totalPayment = (data['totalPayment'] ?? 0).toDouble();

        print('Mapped values:');
        print('currentAmountDue: $currentAmountDue');
        print('dueDate: $dueDate');
        print('previousReading: $previousReading');
        print('currentReading: $currentReading');
        print('waterConsumption: $waterConsumption');
        print('maintenanceFee: $maintenanceFee');
        print('taxes: $taxes');
        print('unpaidBill: $unpaidBill');
        print('totalPayment: $totalPayment');

        notifyListeners();
      } else {
        throw Exception('No billing data returned from service.');
      }
    } catch (e) {
      print('Error fetching bill via Service API: $e');
    }
  }

  // --- Update Methods ---
  void updateUsage({
    required double prev,
    required double curr,
    DateTime? prevDate,
    DateTime? currDate,
  }) {
    previousReading = prev;
    currentReading = curr;
    if (prevDate != null) previousReadingDate = prevDate;
    if (currDate != null) currentReadingDate = currDate;
    notifyListeners();
  }

  void updateBreakdown({
    double? water,
    double? maintenance,
    double? tax,
    double? unpaid,
    double? total,
  }) {
    if (water != null) waterConsumption = water;
    if (maintenance != null) maintenanceFee = maintenance;
    if (tax != null) taxes = tax;
    if (unpaid != null) unpaidBill = unpaid;
    if (total != null) totalPayment = total;
    notifyListeners();
  }

  void updateCurrentBill({double? amountDue, DateTime? newDueDate}) {
    if (amountDue != null) currentAmountDue = amountDue;
    if (newDueDate != null) dueDate = newDueDate;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class BillBreakdownProvider extends ChangeNotifier {
  // --- Current Billing Info ---
  double currentAmountDue = 842.75; // realistic total amount due
  DateTime dueDate = DateTime(2025, 10, 25); // due in ~2 weeks

  // --- Usage Details ---
  double previousReading = 3580.420; // previous meter reading (m³)
  double currentReading = 3604.685; // current reading (m³)

  // --- Reading Dates ---
  DateTime previousReadingDate = DateTime(2025, 9, 5); // Sept 5, 2025
  DateTime currentReadingDate = DateTime(2025, 10, 5); // Oct 5, 2025

  // --- Billing Breakdown ---
  double waterConsumption = 650.50; // main water charge
  double maintenanceFee = 75.00; // fixed monthly maintenance
  double taxes = 35.25; // environmental + local tax
  double unpaidBill = 82.00; // previous unpaid balance
  double totalPayment = 842.75; // matches total amount due

  // --- Computed getters ---
  String get totalUsage {
    final usage = currentReading - previousReading;
    return "${usage.toStringAsFixed(3)}";
  }

  int get readingIntervalDays {
    return currentReadingDate.difference(previousReadingDate).inDays;
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

  // --- Optional: computed total (if you want to auto-compute later) ---
  double get computedTotal =>
      waterConsumption + maintenanceFee + taxes + unpaidBill;
}

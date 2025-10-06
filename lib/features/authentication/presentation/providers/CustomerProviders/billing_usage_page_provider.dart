import 'package:flutter/material.dart';

class BillBreakdownProvider extends ChangeNotifier {
  // --- Usage Details ---
  double previousReading = 1200.123;
  double currentReading = 1220.125;

  // --- Billing Breakdown ---
  double waterConsumption = 1450.23;
  double maintenanceFee = 50.00;
  double taxes = 1.00;
  double unpaidBill = 4410.13;
  double totalPayment = 3124.41;

  String get totalUsage {
    final usage = currentReading - previousReading;
    return "${usage.toStringAsFixed(3)} m³";
  }

  // --- Methods for updating values (useful for future API integration) ---
  void updateUsage({required double prev, required double curr}) {
    previousReading = prev;
    currentReading = curr;
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

  // --- Optional: computed total (if you want to auto-compute later) ---
  double get computedTotal =>
      waterConsumption + maintenanceFee + taxes + unpaidBill;
}

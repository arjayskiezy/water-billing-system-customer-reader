import '../BillingHistory/billing_history.dart';
import 'package:flutter/material.dart';

class BillBreakdownPage extends StatelessWidget {
  const BillBreakdownPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper for a billing row
    Widget billingRow(
      String label,
      String value, {
      TextStyle? labelStyle,
      TextStyle? valueStyle,
      VoidCallback? onTap, // 👈 allow tapping
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: labelStyle ?? const TextStyle(fontSize: 16)),
              Text(value, style: valueStyle ?? const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Billing Breakdown"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Summary of your current charges, past payments, and overall account balance.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Usage Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  billingRow('Previous Reading', '1200.123 m³'),
                  billingRow('Current Reading', '1220.121 m³'),
                  const Divider(height: 36),
                  billingRow(
                    'Total Usage',
                    '452.324 m³',
                    valueStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const Divider(height: 36),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Billing Breakdown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  billingRow('Water Consumption', '₱1450.23'),
                  billingRow('Maintenance Fee', '₱50.00'),
                  billingRow('Taxes', '₱1.00'),
                  billingRow(
                    'Unpaid Bill',
                    '₱4410.13',
                    valueStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BillingHistoryPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 36),
                  billingRow(
                    'Total Payment',
                    '₱3124.41',
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    valueStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const Divider(height: 36),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'Please ensure that your bill is paid before the due date. For assistance, contact our customer service.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 80), // space for bottom button
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Handle payment action
                print('Pay Now pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Pay Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

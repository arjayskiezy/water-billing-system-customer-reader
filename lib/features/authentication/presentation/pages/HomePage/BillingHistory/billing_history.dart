import 'package:flutter/material.dart';

class BillingHistoryPage extends StatefulWidget {
  const BillingHistoryPage({super.key});

  @override
  State<BillingHistoryPage> createState() => _BillingHistoryPageState();
}

class _BillingHistoryPageState extends State<BillingHistoryPage> {
  // Dummy billing data
  final List<Map<String, dynamic>> billingData = const [
    {
      'month': 'August 12, 2025',
      'dueDate': 'September 18, 2025',
      'amount': 2341.51,
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
      'month': 'July 12, 2025',
      'dueDate': 'August 18, 2025',
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
      'month': 'June 14, 2025',
      'dueDate': 'July 25, 2025',
      'amount': 11231.50,
      'usage': 4121.217,
      'paid': false,
      'breakdown': {
        'Water Consumption': 8900.00,
        'Maintenance Fee': 80.00,
        'Taxes': 21.50,
        'Unpaid Bill': 2230.00,
      },
    },
    {
      'month': 'April 14, 2025',
      'dueDate': 'May 31, 2025',
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

  String _filter = "All"; // Default filter

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter logic
    final filteredData = billingData.where((item) {
      if (_filter == "Paid") return item['paid'] == true;
      if (_filter == "Unpaid") return item['paid'] == false;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Billing History"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text("All"),
                  selected: _filter == "All",
                  onSelected: (_) => setState(() => _filter = "All"),
                  selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  showCheckmark: false, // 👈 removes checkmark
                ),
                ChoiceChip(
                  label: const Text("Paid"),
                  selected: _filter == "Paid",
                  onSelected: (_) => setState(() => _filter = "Paid"),
                  selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  showCheckmark: false, // 👈 removes checkmark
                ),
                ChoiceChip(
                  label: const Text("Unpaid"),
                  selected: _filter == "Unpaid",
                  onSelected: (_) => setState(() => _filter = "Unpaid"),
                  selectedColor: Colors.red[100],
                  showCheckmark: false, // 👈 removes checkmark
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final item = filteredData[index];
                final breakdown = item['breakdown'] as Map<String, double>;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: item['paid']
                      ? theme
                            .colorScheme
                            .primary // Paid = blue
                      : Colors.red[400], // Unpaid = light red
                  elevation: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      backgroundColor: item['paid']
                          ? Colors.blue[700]
                          : Colors.red[400],
                      collapsedBackgroundColor: item['paid']
                          ? Colors.blue[900]
                          : Colors.red[300],
                      childrenPadding: const EdgeInsets.all(16),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['month'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '₱${item['amount'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Due: ${item['dueDate']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${item['usage'].toStringAsFixed(3)} m³',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: item['paid']
                                    ? Colors.green
                                    : Colors.yellow[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['paid'] ? 'Paid' : 'Unpaid',
                                style: TextStyle(
                                  color: item['paid']
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Breakdown section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: breakdown.entries.map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.key,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '₱${e.value.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

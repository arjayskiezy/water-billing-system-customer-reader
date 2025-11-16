import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/LoginProvider/auth_provider.dart';
import '../../../providers/CustomerProviders/billing_history_page_provider.dart';

class BillingHistoryPage extends StatefulWidget {
  const BillingHistoryPage({super.key});

  @override
  State<BillingHistoryPage> createState() => _BillingHistoryPageState();
}

class _BillingHistoryPageState extends State<BillingHistoryPage> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Fetch data on page load
    Future.microtask(() {
      Provider.of<BillingHistoryProvider>(
        context,
        listen: false,
      ).fetchBillingHistory(authProvider.accountNumber.toString());
    });
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Access the provider inside build method
    final provider = Provider.of<BillingHistoryProvider>(context);
    final filteredData = provider.billingData;

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
            child: Theme(
              data: theme.copyWith(
                chipTheme: theme.chipTheme.copyWith(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
              ),
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text("All"),
                    selected: provider.filter == "All",
                    onSelected: (_) => provider.setFilter("All"),
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                    showCheckmark: false,
                  ),
                  ChoiceChip(
                    label: const Text("Paid"),
                    selected: provider.filter == "Paid",
                    onSelected: (_) => provider.setFilter("Paid"),
                    selectedColor: Colors.green[100],
                    showCheckmark: false,
                  ),
                  ChoiceChip(
                    label: const Text("Unpaid"),
                    selected: provider.filter == "Unpaid",
                    onSelected: (_) => provider.setFilter("Unpaid"),
                    selectedColor: Colors.red[100],
                    showCheckmark: false,
                  ),
                ],
              ),
            ),
          ),

          // Billing history list
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredData.isEmpty
                ? const Center(
                    child: Text(
                      "No billing history found",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: item.paid
                            ? theme.colorScheme.primary
                            : Colors.red[400],
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
                            backgroundColor: item.paid
                                ? Colors.green[700]
                                : Colors.red[700],
                            collapsedBackgroundColor: item.paid
                                ? Colors.green[500]
                                : Colors.red[500],
                            childrenPadding: const EdgeInsets.all(16),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  provider.formatDate(item.month),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '₱${item.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'Due: ${provider.formatDate(item.dueDate)}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      '${item.usage.toStringAsFixed(3)} m³',
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
                                      color: item.paid
                                          ? Colors.green
                                          : Colors.yellow[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item.paid ? 'Paid' : 'Unpaid',
                                      style: TextStyle(
                                        color: item.paid
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
                                children: item.breakdown.entries.map((e) {
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
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to LoginPage and remove all previous routes
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Back to Dashboard',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

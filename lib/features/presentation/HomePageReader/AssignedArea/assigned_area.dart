import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../InputReadings/input_readings.dart';
import '../../../providers/ReaderProviders/assigned_area_provider.dart';
import '../../../shared/customer&reader_storage.dart';

class AssignedAreaPage extends StatefulWidget {
  const AssignedAreaPage({super.key});

  @override
  State<AssignedAreaPage> createState() => _AssignedAreaPageState();
}

class _AssignedAreaPageState extends State<AssignedAreaPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignedAreas();
  }

  Future<void> _loadAssignedAreas() async {
    final storage = CustomerStorage();
    final user = await storage.getUser();
    if (user != null && user['userId'] != null) {
      await context.read<AssignedAreaProvider>().fetchAssignedAreas(
        user['userId'],
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final provider = Provider.of<AssignedAreaProvider>(context);
    final filteredList = provider.filteredAreas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meters Assigned'),
        centerTitle: true,
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      onChanged: provider.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search by name...',
                        prefixIcon: Icon(Icons.search, color: colors.primary),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Filter chips
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          chipTheme: Theme.of(context).chipTheme.copyWith(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: Wrap(
                          spacing: 8,
                          children: [
                            ChoiceChip(
                              label: const Text("All"),
                              selected: provider.selectedFilter == "All",
                              onSelected: (_) => provider.setFilter("All"),
                              selectedColor: colors.primary.withOpacity(0.2),
                              showCheckmark: false,
                            ),
                            ChoiceChip(
                              label: const Text("Pending"),
                              selected: provider.selectedFilter == "Pending",
                              onSelected: (_) => provider.setFilter("Pending"),
                              selectedColor: Colors.orange[100],
                              showCheckmark: false,
                            ),
                            ChoiceChip(
                              label: const Text("Completed"),
                              selected: provider.selectedFilter == "Completed",
                              onSelected: (_) =>
                                  provider.setFilter("Completed"),
                              selectedColor: Colors.green[100],
                              showCheckmark: false,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Assigned Areas List
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh:
                            _loadAssignedAreas, // Calls your existing fetch function
                        child: filteredList.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.5,
                                    child: Center(
                                      child: Text(
                                        'No results found',
                                        style: TextStyle(
                                          color: colors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final area = filteredList[index];
                                  final isCompleted =
                                      area['status'] == 'Completed';
                                  return _buildAreaCard(
                                    context,
                                    area,
                                    isCompleted,
                                    colors,
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildAreaCard(
    BuildContext context,
    Map<String, String> area,
    bool isCompleted,
    ColorScheme colors,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Open WaterReadingPage as a modal
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                  child: Material(
                    child: WaterReadingPage(
                      areaName: area['ownerName']!,
                      meterNumber: area['meterNumber']!,
                      isEditing: isCompleted,
                      previousReading: area['lastReading'] ?? '-',
                      address: area['address'] ?? '-',
                    ),
                  ),
                ),
              );
            },
          );
        },

        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            leading: CircleAvatar(
              radius: 15,
              backgroundColor: colors.primary.withOpacity(0.1),
              child: Icon(Icons.location_on, color: colors.primary),
            ),
            title: Text(
              area['meterNumber']!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colors.primary,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              area['address'] ?? '',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                area['status']!,
                style: TextStyle(
                  color: isCompleted ? Colors.green[800] : Colors.orange[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Assigned Areas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
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
                    const SizedBox(height: 16),

                    // Filter chips
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          chipTheme: Theme.of(context).chipTheme.copyWith(
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
                              onSelected: (_) => provider.setFilter("Completed"),
                              selectedColor: Colors.green[100],
                              showCheckmark: false,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Assigned Areas List
                    Expanded(
                      child: filteredList.isEmpty
                          ? Center(
                              child: Text(
                                'No results found',
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
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
    return Container(
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
          area['ownerName']!, // use ownerName from backend
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.primary,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          area['address'] ?? '', // dynamic address
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WaterReadingPage(
                      areaName: area['ownerName']!,
                      meterNumber: area['meterNumber']!,
                      isEditing: isCompleted,
                      previousReading: area['lastReading'] ?? '-',
                      address: area['address'] ?? '-',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted
                    ? colors.primary
                    : colors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(60, 32),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
              child: Text(
                isCompleted ? 'Edit' : 'Add',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 4),
            Container(
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
          ],
        ),
      ),
    );
  }
}

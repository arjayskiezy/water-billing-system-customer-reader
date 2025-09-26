import 'package:flutter/material.dart';
import '../InputReadings/input_readings.dart'; // Make sure this imports the updated WaterReadingPage

class AssignedAreaPage extends StatefulWidget {
  const AssignedAreaPage({super.key});

  @override
  State<AssignedAreaPage> createState() => _AssignedAreaPageState();
}

class _AssignedAreaPageState extends State<AssignedAreaPage> {
  String selectedFilter = 'All';
  String searchQuery = '';

  final List<Map<String, String>> assignedAreas = [
    {'name': 'Domeng Martin', 'status': 'Completed'},
    {'name': 'Alden Richard', 'status': 'Pending'},
    {'name': 'Maine Mendoza', 'status': 'Pending'},
    {'name': 'Richard Mille', 'status': 'Pending'},
    {'name': 'Joshua Discaya', 'status': 'Pending'},
    {'name': 'Kalibangon Co', 'status': 'Pending'},
    {'name': 'Jinggoy Estrada', 'status': 'Pending'},
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Filtered and searched list
    final filteredList = assignedAreas.where((area) {
      final matchesStatus =
          selectedFilter == 'All' || area['status'] == selectedFilter;
      final matchesSearch = area['name']!.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesStatus && matchesSearch;
    }).toList();

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                onChanged: (value) => setState(() => searchQuery = value),
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

              // Filter Buttons
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterButton('All', colors),
                    _buildFilterButton('Pending', colors),
                    _buildFilterButton('Completed', colors),
                  ],
                ),
              ),
              const SizedBox(height: 16),

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
                          final isCompleted = area['status'] == 'Completed';
                          return _buildAreaCard(area, isCompleted, colors);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Filter Button
  Widget _buildFilterButton(String label, ColorScheme colors) {
    final bool selected = selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.primary),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() => selectedFilter = label),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : colors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Area Card
  Widget _buildAreaCard(
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
          radius: 10,
          backgroundColor: colors.primary.withOpacity(0.1),
          child: Icon(Icons.location_on, color: colors.primary),
        ),
        title: Text(
          area['name']!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.primary,
            fontSize: 12,
          ),
        ),
        subtitle: const Text(
          'Magallanes Street',
          style: TextStyle(color: Colors.grey),
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
                      areaName: area['name']!,
                      isEditing: isCompleted,
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                area['status']!,
                style: TextStyle(
                  color: isCompleted ? Colors.green[800] : Colors.orange[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

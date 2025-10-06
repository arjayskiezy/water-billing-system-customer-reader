import 'package:flutter/material.dart';

class AssignedAreaProvider extends ChangeNotifier {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<Map<String, String>> _assignedAreas = [
    {'name': 'Domeng Martins', 'status': 'Completed'},
    {'name': 'Alden Richard', 'status': 'Pending'},
    {'name': 'Maine Mendoza', 'status': 'Pending'},
    {'name': 'Richard Mille', 'status': 'Pending'},
    {'name': 'Joshua Discaya', 'status': 'Pending'},
    {'name': 'Kalibangon Co', 'status': 'Pending'},
    {'name': 'Jinggoy Estrada', 'status': 'Pending'},
  ];

  // Getters
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  List<Map<String, String>> get filteredAreas {
    return _assignedAreas.where((area) {
      final matchesStatus =
          _selectedFilter == 'All' || area['status'] == _selectedFilter;
      final matchesSearch = area['name']!.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchesStatus && matchesSearch;
    }).toList();
  }

  // Update filter
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Update search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}

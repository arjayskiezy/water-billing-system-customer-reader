// import 'package:flutter/material.dart';
//
// class AssignedAreaProvider extends ChangeNotifier {
//   String _selectedFilter = 'All';
//   String _searchQuery = '';
//
//   final List<Map<String, String>> _assignedAreas = [
//     {'name': 'Domeng Martins', 'status': 'Completed'},
//     {'name': 'Alden Richard', 'status': 'Pending'},
//     {'name': 'Maine Mendoza', 'status': 'Pending'},
//     {'name': 'Richard Mille', 'status': 'Pending'},
//     {'name': 'Joshua Discaya', 'status': 'Pending'},
//     {'name': 'Kalibangon Co', 'status': 'Pending'},
//     {'name': 'Jinggoy Estrada', 'status': 'Pending'},
//   ];
//
//   // Getters
//   String get selectedFilter => _selectedFilter;
//   String get searchQuery => _searchQuery;
//
//   List<Map<String, String>> get filteredAreas {
//     return _assignedAreas.where((area) {
//       final matchesStatus =
//           _selectedFilter == 'All' || area['status'] == _selectedFilter;
//       final matchesSearch = area['name']!.toLowerCase().contains(
//         _searchQuery.toLowerCase(),
//       );
//       return matchesStatus && matchesSearch;
//     }).toList();
//   }
//
//   // Update filter
//   void setFilter(String filter) {
//     _selectedFilter = filter;
//     notifyListeners();
//   }
//
//   // Update search query
//   void setSearchQuery(String query) {
//     _searchQuery = query;
//     notifyListeners();
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../api/service.dart';

class AssignedAreaProvider extends ChangeNotifier {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  List<Map<String, String>> _assignedAreas = [];

  // Getters
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  List<Map<String, String>> get filteredAreas {
    return _assignedAreas.where((area) {
      final matchesStatus =
          _selectedFilter == 'All' || area['status'] == _selectedFilter;
      final matchesSearch = area['ownerName']!.toLowerCase().contains(
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

  // -------------------- Fetch data from backend --------------------
  Future<void> fetchAssignedAreas(int readerId) async {
    try {
      final response = await ApiService.get(
        '/reader/assigned-area/reader/$readerId',
      );

      // Check if response is list or map
      final List<dynamic> data = response is List
          ? response
          : response['data'] ?? [];

      _assignedAreas = data.map<Map<String, String>>((item) {
        final lastReading = item['lastReading'];
        return {
          'meterNumber': item['meterNumber'] ?? '',
          'ownerName': item['ownerName'] ?? '',
          'address': item['address'] ?? '',
          'lastReading': lastReading?.toString() ?? '0.0',
          'status': (lastReading != null && lastReading != '')
              ? 'Completed'
              : 'Pending',
        };
      }).toList();

      print('Fetched ${_assignedAreas.length} assigned areas'); // debug
      notifyListeners();
    } catch (e) {
      print('Failed to fetch assigned areas: $e');
      _assignedAreas = [];
      notifyListeners();
    }
  }
}

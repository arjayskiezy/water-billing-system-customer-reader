import 'dart:convert';
import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../database/database_helper.dart';

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

  /// Format status string for UI consistency (capitalize first letter)
  String _formatStatus(String status) {
    if (status.isEmpty) return 'Pending';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  // -------------------- Fetch data from backend and SQLite --------------------
  /// Fetch assigned areas for [readerId].
  ///
  /// If [forceRefresh] is false (default) this will first try to load cached
  /// assigned areas from SQLite and return early if any cached rows exist.
  /// Set [forceRefresh] to true to always attempt a network fetch.
  Future<void> fetchAssignedAreas(int readerId, {bool forceRefresh = false}) async {
    final dbHelper = DatabaseHelper();

    // If we are not forcing a refresh, try loading from cache first
    if (!forceRefresh) {
      final cached = await dbHelper.getAssignedAreas();
      if (cached.isNotEmpty) {
        _assignedAreas = cached.map<Map<String, String>>((item) {
          return {
            'meterNumber': item['meterNumber'] ?? '',
            'ownerName': item['ownerName'] ?? '',
            'address': item['address'] ?? '',
            'lastReading': item['lastReading'] ?? '0.0',
            'status': item['status'] ?? 'Pending',
          };
        }).toList();

        print('Loaded ${_assignedAreas.length} assigned areas from SQLite cache (no network call)');
        notifyListeners();
        return;
      }
    }

    try {
      // Step 1: Try fetching from API
      final response = await ApiService.get(
        '/reader/assigned-area/reader/$readerId',
      );

      final List<dynamic> data = response is List
          ? response
          : response['data'] ?? [];

      // Step 2: Map API data to our structure
      _assignedAreas = data.map<Map<String, String>>((item) {
        final lastReading = item['lastReading'];
        final status = item['status'] ?? 'pending'; // Use status from backend
        return {
          'meterNumber': item['meterNumber'] ?? '',
          'ownerName': item['ownerName'] ?? '',
          'address': item['address'] ?? '',
          'lastReading': lastReading?.toString() ?? '0.0',
          'status': _formatStatus(status), // Capitalize for UI consistency
        };
      }).toList();

      // Step 3: Save/update data to SQLite cache
      await dbHelper.upsertAssignedAreas(_assignedAreas);

      print('Fetched and cached ${_assignedAreas.length} assigned areas');
    } catch (e) {
      print('Failed to fetch from API, loading from SQLite: $e');

      // Step 4: Load from SQLite if API fails
      final cached = await DatabaseHelper().getAssignedAreas();
      _assignedAreas = cached.map<Map<String, String>>((item) {
        return {
          'meterNumber': item['meterNumber'] ?? '',
          'ownerName': item['ownerName'] ?? '',
          'address': item['address'] ?? '',
          'lastReading': item['lastReading'] ?? '0.0',
          'status': item['status'] ?? 'Pending',
        };
      }).toList();

      print('Loaded ${_assignedAreas.length} assigned areas from SQLite cache');
    }

    notifyListeners();
  }
}

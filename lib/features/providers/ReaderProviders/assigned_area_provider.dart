import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../database/database_helper.dart';

class AssignedAreaProvider extends ChangeNotifier {
  // ------------------- Private fields -------------------
  String _selectedFilter = 'All';
  String _searchQuery = '';
  List<Map<String, String>> _assignedAreas = [];

  // Optional loading & error state
  bool _isLoading = false;
  String? _error;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // ------------------- Getters -------------------
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Returns the list of assigned areas filtered by search and status
  List<Map<String, String>> get filteredAreas {
    return _assignedAreas.where((area) {
      final matchesStatus =
          _selectedFilter == 'All' || area['status'] == _selectedFilter;

      final matchesSearch =
          area['meterNumber']!.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          area['ownerName']!.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          area['address']!.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesStatus && matchesSearch;
    }).toList();
  }

  // ------------------- Public Methods -------------------

  /// Update the filter (All, Pending, Completed)
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  /// Update the search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Fetch assigned areas for a reader
  /// - [forceRefresh] bypasses cache if true
  Future<void> fetchAssignedAreas(
    int readerId, {
    bool forceRefresh = false,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool shouldFetchFromApi = forceRefresh;

      // ---------------- Load cached data first if not forcing ----------------
      if (!forceRefresh) {
        final cached = await _dbHelper.getAssignedAreas();
        if (cached.isNotEmpty) {
          _assignedAreas = cached.map(_mapAssignedArea).toList();
          notifyListeners(); // Update UI immediately with cached data
        } else {
          shouldFetchFromApi = true; // no cache, must fetch
        }
      }

      // ---------------- Fetch from API only if needed ----------------
      if (shouldFetchFromApi) {
        final response = await ApiService.get(
          '/reader/assigned-area/reader/$readerId',
        );

        final List<dynamic> data =
            (response is List ? response : (response?['data'] ?? []))
                as List<dynamic>;

        // Map API data to our structure
        _assignedAreas = data.map(_mapAssignedArea).toList();

        // Save/update to SQLite cache
        await _dbHelper.upsertAssignedAreas(_assignedAreas);

        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      // If API fails and list is empty, load from cache
      if (_assignedAreas.isEmpty) {
        final cached = await _dbHelper.getAssignedAreas();
        _assignedAreas = cached.map(_mapAssignedArea).toList();
      }
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------- Private Helpers -------------------

  /// Maps raw API/SQLite data to our internal model
  Map<String, String> _mapAssignedArea(dynamic item) {
    final lastReading = item['lastReading']?.toString() ?? '0.0';
    final status = _formatStatus(item['status'] ?? 'pending');

    return {
      'meterNumber': item['meterNumber'] ?? '',
      'ownerName': item['ownerName'] ?? '',
      'address': item['address'] ?? '',
      'lastReading': lastReading,
      'status': status,
    };
  }

  /// Capitalize status for consistent UI display
  String _formatStatus(String status) {
    if (status.isEmpty) return 'Pending';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
}

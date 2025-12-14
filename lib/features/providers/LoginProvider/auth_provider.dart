import 'dart:convert';
import 'package:flutter/material.dart';
import '../../shared/customer&reader_storage.dart';
import '../../api/api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum UserRole { customer, reader }

class AuthProvider extends ChangeNotifier {
  // ============== DEPENDENCIES ==============
  final CustomerStorage _storage = CustomerStorage();

  // ============== STATE VARIABLES ==============
  bool _loggedIn = false;
  bool _isLoading = true;
  UserRole? _role;
  bool _tokenSynced = false;

  // User data
  String? _firstName;
  String? _lastName;
  String? _accountNumber;
  String? _meterNumber;
  String? _readerCode;
  int? _userId;

  // ============== GETTERS ==============
  bool get loggedIn => _loggedIn;
  bool get isLoading => _isLoading;
  UserRole? get role => _role;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get accountNumber => _accountNumber;
  String? get meterNumber => _meterNumber;
  String? get readerCode => _readerCode;
  int? get userId => _userId;

  // ============== PUBLIC METHODS ==============
  /// Load user data from local storage
  Future<void> loadUser() async {
    final userData = await _storage.getUser();
    if (userData != null) {
      _loadUserFromData(userData);
      _loggedIn = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Authenticate user with backend
  Future<String> login({
    required String accountNumber,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('/login', {
        'accountNumber': accountNumber,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await _handleLoginSuccess(data);
          return data['role'];
        }
      }
      return 'error';
    } catch (e) {
      print('Login error: $e');
      return 'error';
    }
  }

  /// Clear user session and local storage
  Future<void> logout() async {
    _clearUserData();
    await _storage.clearUser();
    notifyListeners();
  }

  // ============== PRIVATE HELPER METHODS ==============
  /// Load user data from decoded JSON/map
  void _loadUserFromData(Map<String, dynamic> userData) {
    _firstName = userData['firstName'];
    _lastName = userData['lastName'];
    _accountNumber = _tryParseInt(userData['accountNumber'])?.toString();
    _meterNumber = _tryParseInt(userData['meterNumber'])?.toString();
    _readerCode = userData['readerCode'];
    _userId = userData['userId'];
    _role = userData['role'] == 'customer'
        ? UserRole.customer
        : UserRole.reader;
  }

  /// Handle successful login response
  Future<void> _handleLoginSuccess(Map<String, dynamic> data) async {
    final String role = data['role'];

    // Update role and login state
    _role = role == 'reader' ? UserRole.reader : UserRole.customer;
    _loggedIn = true;

    // Parse and assign user data
    final split = _splitName(data['name'] ?? '');
    _firstName = split['firstName'];
    _lastName = split['lastName'];
    _accountNumber = _tryParseInt(data['accountNumber'])?.toString();
    _meterNumber = _tryParseInt(data['meterNumber'])?.toString();
    _readerCode = data['readerCode'];
    _userId = data['id'];

    // Persist to storage
    await _storage.saveUser(
      firstName: _firstName!,
      lastName: _lastName!,
      accountNumber: _accountNumber,
      meterNumber: _meterNumber,
      readerCode: _readerCode,
      userId: _userId,
      role: role,
    );

    await syncDeviceToken(userId: _userId!);

    notifyListeners();
  }

  /// Clear all user data
  void _clearUserData() {
    _loggedIn = false;
    _role = null;
    _firstName = null;
    _lastName = null;
    _accountNumber = null;
    _meterNumber = null;
    _readerCode = null;
    _userId = null;
  }

  /// Parse string or int to int safely
  int? _tryParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Split full name into first and last name
  Map<String, String> _splitName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length == 1) {
      return {'firstName': parts[0], 'lastName': ''};
    } else {
      return {'firstName': parts.first, 'lastName': parts.sublist(1).join(' ')};
    }
  }

  Future<void> syncDeviceToken({required int userId}) async {
    if (_tokenSynced) return; // avoid duplicates

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    try {
      final payload = {
        'deviceToken': token,
        'platform': 'android',
        'userId': userId,
      };

      // Debug: print the payload
      print('Sending device token payload: $payload');

      await ApiService.post('/user/device-token', payload);
    } catch (e) {
      print('Error sending device token: $e');
    }
  }
}

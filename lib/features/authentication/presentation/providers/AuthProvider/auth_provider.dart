import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../shared/customer_storage.dart';
import '../../../api/service.dart';

enum UserRole { customer, reader }

class AuthProvider extends ChangeNotifier {
  bool _loggedIn = false;
  UserRole? _role;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _firstName;
  String? _lastName;
  String? _accountNumber;
  String? _meterNumber;
  String? _readerCode;
  int? _userId;

  final CustomerStorage _storage = CustomerStorage();

  // -------------------- Getters --------------------
  bool get loggedIn => _loggedIn;
  UserRole? get role => _role;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get accountNumber => _accountNumber;
  String? get meterNumber => _meterNumber;
  String? get readerCode => _readerCode;
  int? get userId => _userId;

  // -------------------- Load user from storage --------------------
  Future<void> loadUser() async {
    final userData = await _storage.getUser();
    if (userData != null) {
      _firstName = userData['firstName'];
      _lastName = userData['lastName'];
      _accountNumber = _tryParseInt(userData['accountNumber'])?.toString();
      _meterNumber = _tryParseInt(userData['meterNumber'])?.toString();
      _readerCode = userData['readerCode'];
      _userId = userData['userId'];
      _role = userData['role'] == 'customer'
          ? UserRole.customer
          : UserRole.reader;
      _loggedIn = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  // -------------------- Utility Helpers --------------------
  int? _tryParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, String> _splitName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length == 1) {
      return {'firstName': parts[0], 'lastName': ''};
    } else {
      return {'firstName': parts.first, 'lastName': parts.sublist(1).join(' ')};
    }
  }

  // -------------------- LOGIN (Real Backend Call) --------------------
  Future<String> login({
    required String accountNumber,
    required String password,
  }) async {
    try {
      // ✅ Use your ApiService instead of hardcoded URL
      final response = await ApiService.post('/login', {
        'accountNumber': accountNumber,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final String role = data['role'];
          _role = role == 'reader' ? UserRole.reader : UserRole.customer;
          _loggedIn = true;

          // Split name and convert types
          final split = _splitName(data['name'] ?? '');
          _firstName = split['firstName'];
          _lastName = split['lastName'];
          _accountNumber = _tryParseInt(data['accountNumber'])?.toString();
          _meterNumber = _tryParseInt(data['meterNumber'])?.toString();
          _readerCode = data['readerCode'];
          _userId = data['id'];

          await _storage.saveUser(
            firstName: _firstName!,
            lastName: _lastName!,
            accountNumber: _accountNumber,
            meterNumber: _meterNumber,
            readerCode: _readerCode,
            userId: _userId,
            role: role,
          );

          notifyListeners();
          return role;
        } else {
          return 'error';
        }
      } else {
        return 'error';
      }
    } catch (e) {
      print('Login error: $e');
      return 'error';
    }
  }

  // -------------------- LOGOUT --------------------
  Future<void> logout() async {
    _loggedIn = false;
    _role = null;
    _firstName = null;
    _lastName = null;
    _accountNumber = null;
    _meterNumber = null;
    _readerCode = null;

    await _storage.clearUser();
    notifyListeners();
  }
}

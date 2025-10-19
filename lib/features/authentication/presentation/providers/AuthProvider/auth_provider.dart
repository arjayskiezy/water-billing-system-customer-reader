import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  int? _accountNumber;
  int? _meterNumber;
  String? _uid;

  final CustomerStorage _storage = CustomerStorage();

  // -------------------- Getters --------------------
  bool get loggedIn => _loggedIn;
  UserRole? get role => _role;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  int? get accountNumber => _accountNumber;
  int? get meterNumber => _meterNumber;
  String? get uid => _uid;

  // -------------------- Load user from storage --------------------
  Future<void> loadUser() async {
    final userData = await _storage.getUser();
    if (userData != null) {
      _firstName = userData['firstName'];
      _lastName = userData['lastName'];
      _accountNumber = _tryParseInt(userData['accountNumber']);
      _meterNumber = _tryParseInt(userData['meterNumber']);
      _uid = userData['uid'];
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
          _accountNumber = _tryParseInt(data['accountNumber']);
          _meterNumber = _tryParseInt(data['meterNumber']);
          _uid = data['readerCode'];

          await _storage.saveUser(
            firstName: _firstName!,
            lastName: _lastName!,
            accountNumber: _accountNumber ?? 0,
            meterNumber: _meterNumber ?? 0,
            uid: _uid,
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
    _uid = null;

    await _storage.clearUser();
    notifyListeners();
  }
}

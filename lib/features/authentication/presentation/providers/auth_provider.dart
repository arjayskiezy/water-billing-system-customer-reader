import 'package:flutter/material.dart';
import '../../api/service.dart';
import '../../shared/customer_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool _loggedIn = false;
  String? _firstName;
  String? _lastName;
  int? _accountNumber;
  int? _meterNumber;

  final CustomerStorage _storage = CustomerStorage();

  bool get loggedIn => _loggedIn;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  int? get accountNumber => _accountNumber;
  int? get meterNumber => _meterNumber;

  /// Load user session from storage (call this on app startup)
  Future<void> loadUser() async {
    final userData = await _storage.getUser();
    if (userData != null) {
      _firstName = userData['firstName'];
      _lastName = userData['lastName'];
      _accountNumber = userData['accountNumber'];
      _meterNumber = userData['meterNumber'];
      _loggedIn = true;
      notifyListeners();
    }
  }

  /// Login with meter number + password
  Future<bool> login(String meterNumber, String password) async {
    final response = await ApiService.login(meterNumber, password);

    if (response != null && response['status'] == 'success') {
      _loggedIn = true;
      _firstName = response['firstName'];
      _lastName = response['lastName'];
      _accountNumber = response['accountNumber'];
      _meterNumber = response['meterNumber'];

      // Save to local storage
      await _storage.saveUser(
        firstName: _firstName!,
        lastName: _lastName!,
        accountNumber: _accountNumber!,
        meterNumber: _meterNumber!,
      );

      notifyListeners();
      return true;
    }
    return false;
  }

  /// Register with full details
  Future<bool> register(Map<String, dynamic> data) async {
    final response = await ApiService.register(data);

    if (response != null && response['status'] == 'success') {
      _loggedIn = true;
      _firstName = response['firstName'];
      _lastName = response['lastName'];
      _accountNumber = response['accountNumber'];
      _meterNumber = response['meterNumber'];

      // Save to local storage
      await _storage.saveUser(
        firstName: _firstName!,
        lastName: _lastName!,
        accountNumber: _accountNumber!,
        meterNumber: _meterNumber!,
      );

      notifyListeners();
      return true;
    }
    return false;
  }

  /// Logout
  Future<void> logout() async {
    _loggedIn = false;
    _firstName = null;
    _lastName = null;
    _accountNumber = null;
    _meterNumber = null;
    await _storage.clearUser();
    notifyListeners();
  }
}

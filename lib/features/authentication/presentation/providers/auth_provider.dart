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
  // Future<String> login(String accountNumber, String password) async {
  //   // Custom test data for admin
  //   const adminAccountNumber = 'admin';
  //   const adminPassword = 'admin123';
  //
  //   // Check if the login is for admin first
  //   if (accountNumber == adminAccountNumber && password == adminPassword) {
  //     // Return role as 'admin'
  //     return 'admin';
  //   }
  //
  //   // Regular user login via API
  //   final response = await ApiService.login(accountNumber, password);
  //
  //   if (response != null && response['status'] == 'success') {
  //     _loggedIn = true;
  //     _firstName = response['firstName'];
  //     _lastName = response['lastName'];
  //     _accountNumber = response['accountNumber'];
  //     _meterNumber = response['meterNumber'];
  //
  //     // Save to local storage
  //     await _storage.saveUser(
  //       firstName: _firstName!,
  //       lastName: _lastName!,
  //       accountNumber: _accountNumber!,
  //       meterNumber: _meterNumber!,
  //     );
  //
  //     notifyListeners();
  //     return 'user'; // <- return 'user' instead of true
  //   }
  //
  //   // Login failed
  //   return 'error';
  // }
  Future<String> login(String accountNumber, String password) async {
    // Custom test data for admin
    const adminAccountNumber = '123';
    const adminPassword = 'admin123';

    // Check if the login is for admin first
    if (accountNumber == adminAccountNumber && password == adminPassword) {
      // Return role as 'admin'
      return 'admin';
    }

    // Dummy login for a regular user
    const dummyUserAccountNumber = '123';
    const dummyUserPassword = 'user123';

    if (accountNumber == dummyUserAccountNumber &&
        password == dummyUserPassword) {
      // Simulate setting user details
      _loggedIn = true;
      _firstName = 'John';
      _lastName = 'Doe';
      _accountNumber = 12345;
      _meterNumber = 12345;

      // Optionally save to local storage
      await _storage.saveUser(
        firstName: _firstName!,
        lastName: _lastName!,
        accountNumber: _accountNumber!,
        meterNumber: _meterNumber!,
      );

      notifyListeners();
      return 'user';
    }

    /*
  // Regular user login via API
  final response = await ApiService.login(accountNumber, password);

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
    return 'user';
  }
  */

    // Login failed
    return 'error';
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

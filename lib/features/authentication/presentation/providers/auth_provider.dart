import 'package:flutter/material.dart';
import '../../shared/customer_storage.dart';

enum UserRole { customer, reader }

class AuthProvider extends ChangeNotifier {
  bool _loggedIn = false;
  UserRole? _role;

  String? _firstName;
  String? _lastName;
  int? _accountNumber; // for customer
  int? _meterNumber; // for customer
  String? _uid; // for reader

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
      _accountNumber = userData['accountNumber'];
      _meterNumber = userData['meterNumber'];
      _uid = userData['uid'];
      _role = userData['role'] == 'customer'
          ? UserRole.customer
          : UserRole.reader;
      _loggedIn = true;
      notifyListeners();
    }
  }

  // -------------------- Login --------------------
  /// Returns 'customer', 'reader', or 'error'
  Future<String> login({
    required String accountNumber,
    required String password,
  }) async {
    // -------------------- Dummy Customer --------------------
    const dummyCustomerUsername = '123456';
    const dummyCustomerPassword = 'cust123';

    if (accountNumber == dummyCustomerUsername &&
        password == dummyCustomerPassword) {
      _role = UserRole.customer;
      _loggedIn = true;
      _firstName = "Jane";
      _lastName = "Doe";
      _accountNumber = 123456;
      _meterNumber = 987654;

      await _storage.saveUser(
        firstName: _firstName!,
        lastName: _lastName!,
        accountNumber: _accountNumber!,
        meterNumber: _meterNumber!,
        role: 'customer',
      );

      notifyListeners();
      return 'customer';
    }

    // -------------------- Dummy Reader --------------------
    const dummyReaderUsername = '123457';
    const dummyReaderPassword = 'read123';

    if (accountNumber == dummyReaderUsername &&
        password == dummyReaderPassword) {
      _role = UserRole.reader;
      _loggedIn = true;
      _firstName = "Justin";
      _lastName = "Nabunturan";
      _uid = "123456";

      await _storage.saveUser(
        firstName: _firstName!,
        lastName: _lastName!,
        uid: _uid!,
        role: 'reader',
      );

      notifyListeners();
      return 'reader';
    }

    // -------------------- API Login (Commented for future) --------------------
    /*
    final response = await ApiService.login(username, password);
    if (response != null && response['status'] == 'success') {
      _role = response['role'] == 'reader' ? UserRole.reader : UserRole.customer;
      _loggedIn = true;
      _firstName = response['firstName'];
      _lastName = response['lastName'];
      _accountNumber = response['accountNumber'];
      _meterNumber = response['meterNumber'];
      _uid = response['uid'];

      await _storage.saveUser(
        firstName: _firstName!,
        lastName: _lastName!,
        accountNumber: _accountNumber ?? 0,
        meterNumber: _meterNumber ?? 0,
        uid: _uid,
        role: response['role'],
      );

      notifyListeners();
      return response['role'];
    }
    */

    // -------------------- Login failed --------------------
    return 'error';
  }

  // -------------------- Logout --------------------
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

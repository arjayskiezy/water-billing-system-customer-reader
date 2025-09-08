import 'package:flutter/material.dart';
import '../../api/service.dart';

class AuthProvider extends ChangeNotifier {
  bool _loggedIn = false;
  String? _userName;
  int? _accountNumber;
  int? _meterNumber;

  bool get loggedIn => _loggedIn;

  String? get userName => _userName;

  int? get accountNumber => _accountNumber;

  int? get meterNumber => _meterNumber;

  // Login using meter number + password
  Future<bool> login(String meterNumber, String password) async {
    final response = await ApiService.login(meterNumber, password);

    if (response != null && response['status'] == 'success') {
      _loggedIn = true;
      _userName = "${response['firstName']} ${response['lastName']}";
      _accountNumber = response['accountNumber'];
      _meterNumber = response['meterNumber'];
      notifyListeners();
      return true;
    }

    return false;
  }

  // Register with all required fields
  Future<bool> register(Map<String, dynamic> data) async {
    final response = await ApiService.register(data);

    if (response != null && response['status'] == 'success') {
      _loggedIn = true;
      _userName = "${response['firstName']} ${response['lastName']}";
      _accountNumber = response['accountNumber'];
      _meterNumber = response['meterNumber'];
      notifyListeners();
      return true;
    }

    return false;
  }

  void logout() {
    _loggedIn = false;
    _userName = null;
    _accountNumber = null;
    _meterNumber = null;
    notifyListeners();
  }
}

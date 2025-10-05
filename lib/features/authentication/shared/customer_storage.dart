import 'package:shared_preferences/shared_preferences.dart';

class CustomerStorage {
  // Save user info
  Future<void> saveUser({
    required String firstName,
    required String lastName,
    String? role, // 'customer' or 'reader'
    int? accountNumber, // for customer
    int? meterNumber, // for customer
    String? uid, // for reader
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    if (accountNumber != null)
      await prefs.setInt('accountNumber', accountNumber);
    if (meterNumber != null) await prefs.setInt('meterNumber', meterNumber);
    if (uid != null) await prefs.setString('uid', uid);
    if (role != null) await prefs.setString('role', role);
    await prefs.setBool('loggedIn', true);
  }

  // Load user info
  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('loggedIn') ?? false) {
      return {
        'firstName': prefs.getString('firstName'),
        'lastName': prefs.getString('lastName'),
        'accountNumber': prefs.getInt('accountNumber'), // nullable
        'meterNumber': prefs.getInt('meterNumber'), // nullable
        'uid': prefs.getString('uid'), // nullable
        'role': prefs.getString('role'), // 'customer' or 'reader'
      };
    }
    return null;
  }

  // Logout
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

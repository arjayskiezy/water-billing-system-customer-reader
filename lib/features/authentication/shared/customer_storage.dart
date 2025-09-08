import 'package:shared_preferences/shared_preferences.dart';

class CustomerStorage {
  // Save user info
  Future<void> saveUser({
    required String firstName,
    required String lastName,
    required int accountNumber,
    required int meterNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setInt('accountNumber', accountNumber);
    await prefs.setInt('meterNumber', meterNumber);
    await prefs.setBool('loggedIn', true);
  }

  // Load user info
  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('loggedIn') ?? false) {
      return {
        'firstName': prefs.getString('firstName'),
        'lastName': prefs.getString('lastName'),
        'accountNumber': prefs.getInt('accountNumber'),
        'meterNumber': prefs.getInt('meterNumber'),
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

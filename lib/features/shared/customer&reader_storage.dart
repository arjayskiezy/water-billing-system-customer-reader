import 'package:shared_preferences/shared_preferences.dart';

class CustomerStorage {
  // Save user info
  Future<void> saveUser({
    required String firstName,
    required String lastName,
    String? role, // 'customer' or 'reader'
    String? accountNumber, // for customer
    String? meterNumber, // for customer
    String? readerCode, // for reader
    int? userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    if (accountNumber != null)
      await prefs.setString('accountNumber', accountNumber);
    if (meterNumber != null) await prefs.setString('meterNumber', meterNumber);
    if (readerCode != null) await prefs.setString('readerCode', readerCode);
    if (role != null) await prefs.setString('role', role);
    if (userId != null) await prefs.setInt('userId', userId);
    await prefs.setBool('loggedIn', true);
  }

  // Load user info
  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('loggedIn') ?? false) {
      return {
        'firstName': prefs.getString('firstName'),
        'lastName': prefs.getString('lastName'),
        'accountNumber': prefs.getString('accountNumber'), // nullable
        'meterNumber': prefs.getString('meterNumber'), // nullable
        'readerCode': prefs.getString('readerCode'), // nullable
        'role': prefs.getString('role'), // 'customer' or 'reader'
        'userId': prefs.getInt('userId'), // nullable
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

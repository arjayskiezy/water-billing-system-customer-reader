import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<Map<String, dynamic>?> login(
    String meterNumber,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'meterNumber': meterNumber, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Login failed: ${response.statusCode} ${response.body}");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> register(
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Register failed: ${response.statusCode} ${response.body}");
      return null;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = 'http://192.168.1.50:8080/mobile';
  static const String baseUrl = 'https://vinita-nonobstetrical-nondurably.ngrok-free.dev/mobile';

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body,
  ) {
    final url = Uri.parse('$baseUrl$endpoint');
    return http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body); 
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}

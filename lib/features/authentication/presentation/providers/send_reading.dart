import '../../api/service.dart';
import 'package:flutter/material.dart';

Future<String> sendReading(Map<String, dynamic> data) async {
  try {
    // Debug print the data being sent
    debugPrint('📤 Sending reading: $data');

    // TODO: Replace this with actual backend call later
    // final response = await ApiService.sendReading(data);
    // debugPrint('📥 Response: $response');
    // if (response['status'] == 'success') return 'success';

    await Future.delayed(const Duration(seconds: 1)); // simulate delay

    debugPrint('✅ Reading sent successfully'); // debug print success
    return 'success';
  } catch (e, stackTrace) {
    // Log the error and stack trace
    debugPrint('❌ Error sending reading: $e');
    debugPrint('Stack trace: $stackTrace');
    return 'error';
  }
}

// static Future<Map<String, dynamic>> sendReading(Map<String, dynamic> data) async {
// final response = await http.post(
// Uri.parse('$baseUrl/api/readings'),
// headers: {'Content-Type': 'application/json'},
// body: jsonEncode(data),
// );
//
// if (response.statusCode == 200) {
// return jsonDecode(response.body);
// } else {
// throw Exception('Failed to send reading');
// }
// }

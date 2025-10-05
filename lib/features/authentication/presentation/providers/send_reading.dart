import '../../api/service.dart';

Future<String> sendReading(Map<String, dynamic> data) async {
  try {
    // Dummy local simulation (you can log it)
    print('📤 Sending reading: $data');

    // TODO: Replace this with backend call later
    // final response = await ApiService.sendReading(data);
    // if (response['status'] == 'success') return 'success';

    await Future.delayed(const Duration(seconds: 1)); // simulate delay
    return 'success';
  } catch (e) {
    print('❌ Error sending reading: $e');
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

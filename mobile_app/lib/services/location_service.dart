import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const String _url =
      "http://127.0.0.1:8000/api/user/location";

  static Future<void> saveLocation({
    required String userId,
    required String state,
    required String district,
    String? village,
    String language = "en",
  }) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "state": state,
        "district": district,
        "village": village,
        "language": language,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to save location");
    }
  }
}

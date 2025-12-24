import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _baseUrl =
      "http://127.0.0.1:8000/api/chat/"; // web / macOS / iOS simulator

  static Future<String> sendMessage({
    required String userId,
    required String message,
    String language = "en",
  }) async {
    final body = {
      "user_id": userId,
      "message": message,
      "language": language,
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Server error ${response.statusCode}");
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data["reply"] is String) {
      return data["reply"]; // ✅ STRING ONLY
    } else {
      throw Exception("Invalid response format");
    }
  }
}

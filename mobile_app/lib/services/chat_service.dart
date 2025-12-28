import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  // 🔴 IMPORTANT: Replace <YOUR_COMPUTER_IP> with your computer's local IP.
  // On Windows, run `ipconfig` in the command prompt and find the "IPv4 Address".
  // It will look like 192.168.x.x
  // For Android Emulator, you can use 10.0.2.2 instead of your local IP.
  static const String _baseUrl =
      "http://192.168.0.105:8000/api/chat/";

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

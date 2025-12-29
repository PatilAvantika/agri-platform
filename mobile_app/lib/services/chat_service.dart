import 'dart:convert';
import 'package:flutter/foundation.dart'; // ✅ kIsWeb
import 'package:http/http.dart' as http;

class ChatService {
  /// Platform-safe backend URL
  static String get _baseUrl {
    // 🌐 Flutter Web
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    // 📱 Android Emulator / Mobile
    return 'http://10.0.2.2:8000';
  }

  static Future<String> sendMessage({
    required String userId,
    required String message,
    String language = "en",
  }) async {
    final Map<String, dynamic> body = {
      "user_id": userId,
      "message": message,
      "language": language,
    };

    final Uri url = Uri.parse('$_baseUrl/api/chat/');

    try {
      debugPrint('Chat: POST $url');
      debugPrint('Chat: Body → $body');

      final response = await http
          .post(
            url,
            headers: const {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint("Chat: STATUS ${response.statusCode}");
      debugPrint("Chat: RESPONSE ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data["reply"] is String) {
          return data["reply"];
        } else {
          throw Exception(
            "Invalid response format: 'reply' field missing",
          );
        }
      }

      // --------- HTTP ERRORS ---------
      if (response.statusCode == 404) {
        throw Exception(
          "Chat service not found. Is backend running?",
        );
      } else if (response.statusCode == 500) {
        throw Exception(
          "Server error. Please try again later.",
        );
      } else if (response.statusCode == 503) {
        throw Exception(
          "Chat service unavailable. Please retry.",
        );
      } else {
        throw Exception(
          "Server error ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("Chat: ERROR → $e");
      throw Exception("Chat service error: $e");
    }
  }

  /// Backend health check
  static Future<bool> isServiceReachable() async {
    try {
      final Uri healthUrl = Uri.parse('$_baseUrl/health');
      final response =
          await http.get(healthUrl).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

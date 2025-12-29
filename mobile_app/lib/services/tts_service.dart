import 'dart:convert';
import 'package:flutter/foundation.dart'; // ✅ for kIsWeb
import 'package:http/http.dart' as http;

class TtsApiService {
  /// Base backend URL depending on platform
  static String get _baseUrl {
    // 🌐 Flutter Web
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    // 📱 Mobile (Android Emulator default)
    // Change this ONLY if using real device
    return 'http://10.0.2.2:8000';
  }

  /// Converts text to speech via backend
  /// Returns FULL audio URL
  Future<String> convertTextToSpeech(String text) async {
    if (text.trim().isEmpty) {
      throw Exception('Text cannot be empty');
    }

    final Uri url = Uri.parse('$_baseUrl/api/tts/tts');

    try {
      debugPrint(
        'TTS: Requesting speech for text: '
        '"${text.substring(0, text.length > 50 ? 50 : text.length)}'
        '${text.length > 50 ? '...' : ''}"',
      );
      debugPrint('TTS: Using backend URL: $_baseUrl');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({'text': text}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        final String? filePath = responseBody['file_path'];
        if (filePath == null || filePath.isEmpty) {
          throw Exception('Invalid TTS response: missing file_path');
        }

        final String audioUrl = '$_baseUrl$filePath';
        debugPrint('TTS: Audio URL generated → $audioUrl');

        return audioUrl;
      } else {
        debugPrint(
          'TTS: HTTP ${response.statusCode} → ${response.body}',
        );
        throw Exception(
          'TTS service error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('TTS: Error occurred → $e');
      throw Exception('TTS service failed: $e');
    }
  }

  /// Simple health check for backend
  Future<bool> isServiceReachable() async {
    try {
      final Uri healthUrl = Uri.parse('$_baseUrl/health');
      final response =
          await http.get(healthUrl).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('TTS: Health check failed → $e');
      return false;
    }
  }
}

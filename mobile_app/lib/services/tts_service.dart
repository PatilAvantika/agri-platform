import 'dart:convert';
import 'package:http/http.dart' as http;

class TtsApiService {
  // IMPORTANT: Use your computer's IP address, not localhost or 127.0.0.1
  // Your phone and computer must be on the same Wi-Fi network.
  static const String _baseUrl = 'http://192.168.0.105:8000'; // <-- CHANGE THIS

  /// Converts the given text to speech by calling the backend API.
  ///
  /// Returns the server path to the generated audio file.
  /// Throws an exception if the request fails.
  Future<String> convertTextToSpeech(String text) async {
    final Uri url = Uri.parse('$_baseUrl/api/tts/tts');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'text': text,
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String filePath = responseBody['file_path'];
        
        // The full URL to the audio file
        return '$_baseUrl$filePath';
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to convert text to speech. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      throw Exception('Failed to connect to the TTS service: $e');
    }
  }
}

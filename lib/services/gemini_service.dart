import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'AIzaSyAEhIaX4EHvfR3iA-WS2HIqdohs3EjI9ns';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

  // Maximum response length to prevent crashes
  static const int _maxResponseLength = 1000;

  Future<String> generateResponse(String prompt) async {
    try {
      // Limit prompt length to prevent issues
      final limitedPrompt =
          prompt.length > 500 ? '${prompt.substring(0, 497)}...' : prompt;

      final response = await http
          .post(
            Uri.parse('$_baseUrl?key=$_apiKey'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': limitedPrompt}
                  ]
                }
              ],
              'generationConfig': {
                'temperature': 0.7,
                'topK': 1,
                'topP': 1,
                // Reduced token limit to prevent large responses
                'maxOutputTokens': 1024,
              },
              'safetySettings': [
                {
                  'category': 'HARM_CATEGORY_HARASSMENT',
                  'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
                },
                {
                  'category': 'HARM_CATEGORY_HATE_SPEECH',
                  'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
                },
                {
                  'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
                  'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
                },
                {
                  'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
                  'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
                }
              ]
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                http.Response('{"error": "Request timed out"}', 408),
          );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          String responseText = data['candidates']?[0]?['content']?['parts']?[0]
                  ?['text'] ??
              'Sorry, I couldn\'t generate a response.';

          // Limit response length to prevent UI issues
          if (responseText.length > _maxResponseLength) {
            responseText =
                '${responseText.substring(0, _maxResponseLength - 3)}...';
          }

          return responseText;
        } catch (parseError) {
          return 'Sorry, I had trouble processing the response.';
        }
      } else {
        return 'Sorry, I couldn\'t generate a response at this time. Please try again later.';
      }
    } catch (e) {
      return 'Sorry, I\'m having trouble connecting. Please check your internet connection and try again.';
    }
  }
}

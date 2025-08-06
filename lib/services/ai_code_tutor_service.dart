import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chatterbox/models/message.dart';

class AiCodeTutorService {
  static const String _textApiUrl = 'https://text.pollinations.ai/openai';

  Future<Message> getResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_textApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'messages': [
            {'role': 'system', 'content': 'You are an expert programming tutor. Provide clear, concise, and helpful code explanations and solutions.'},
            {'role': 'user', 'content': prompt}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        final aiResponseText = jsonResponse['choices'][0]['message']['content'] as String;
        return Message(text: aiResponseText, isUser: false);
      } else {
        return Message(text: 'Error: Could not get a response from the AI Code Tutor.', isUser: false);
      }
    } catch (e) {
      return Message(text: 'An error occurred with the AI Code Tutor. Please check your internet connection.', isUser: false);
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chatterbox/models/message.dart';

class AiTranslatorService {
  static const String _textApiUrl = 'https://text.pollinations.ai/openai';

  Future<Message> getResponse(String prompt, String targetLanguage) async {
    try {
      // Construct a robust system message for translation.
      final systemMessage = 'You are an expert language translator. '
                            'Your task is to translate the given text to "$targetLanguage". '
                            'Provide only the translated text and nothing else. '
                            'Do not include any conversational filler, explanations, or quotes.';

      // Create the API request body with the enhanced prompt.
      final response = await http.post(
        Uri.parse(_textApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'messages': [
            {'role': 'system', 'content': systemMessage},
            {'role': 'user', 'content': prompt}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        final aiResponseText = jsonResponse['choices'][0]['message']['content'] as String;
        return Message(text: aiResponseText, isUser: false);
      } else {
        return Message(text: 'Error: Could not get a response from the AI Translator.', isUser: false);
      }
    } catch (e) {
      return Message(text: 'An error occurred with the AI Translator. Please check your internet connection.', isUser: false);
    }
  }
}
import 'package:chatterbox/models/message.dart';

class AiImageGeneratorService {
  static const String _imageApiUrl = 'https://image.pollinations.ai/prompt/';

  Future<Message> getResponse(String prompt) async {
    try {
      final uri = Uri.parse('$_imageApiUrl${Uri.encodeComponent(prompt)}');
      return Message(imageUrl: uri.toString(), isUser: false);
    } catch (e) {
      return Message(text: 'Error: Could not generate the image link.', isUser: false);
    }
  }
}
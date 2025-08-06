import 'package:chatterbox/models/ai_model.dart';
import 'message.dart';

class ChatSession {
  final String id;
  String title;
  List<Message> messages;
  String lastMessage;
  String firstUserMessage;
  final AiModelType modelType;

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.lastMessage,
    required this.firstUserMessage,
    this.modelType = AiModelType.textWriter, // Default for backward compatibility
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'messages': messages.map((m) => m.toJson()).toList(),
    'lastMessage': lastMessage,
    'firstUserMessage': firstUserMessage,
    'modelType': modelType.name, // Save the enum by its name
  };

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List).map((m) => Message.fromJson(m)).toList(),
      lastMessage: json['lastMessage'] ?? '',
      firstUserMessage: json['firstUserMessage'] ?? '',
      modelType: AiModelType.values.firstWhere(
        (e) => e.name == json['modelType'],
        orElse: () => AiModelType.textWriter, // Default if not found or null
      ),
    );
  }
  
  void updateLastMessage(String newMessage) {
    lastMessage = newMessage;
  }
}

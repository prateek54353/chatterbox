import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:chatterbox/models/chat_session.dart';
import 'package:chatterbox/models/ai_model.dart';
import 'package:chatterbox/screens/text_writer_chat_screen.dart'; // Import the default chat screen
import 'package:chatterbox/screens/image_generator_chat_screen.dart';
import 'package:chatterbox/screens/code_tutor_chat_screen.dart';
import 'package:chatterbox/screens/translator_chat_screen.dart';

class RecentChatsScreen extends StatefulWidget {
  const RecentChatsScreen({super.key});

  @override
  State<RecentChatsScreen> createState() => _RecentChatsScreenState();
}

class _RecentChatsScreenState extends State<RecentChatsScreen> {
  List<ChatSession> _chatHistory = [];
  static const _chatHistoryKey = 'chat_history';

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_chatHistoryKey) ?? [];
    final List<ChatSession> loadedSessions = [];
    for (var jsonString in historyJson) {
      try {
        loadedSessions.add(ChatSession.fromJson(jsonDecode(jsonString)));
      } catch (e) {
        // print('Error loading chat session: $e'); // Removed print statement
      }
    }
    setState(() {
      _chatHistory = loadedSessions;
    });
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson =
        _chatHistory.map((session) => jsonEncode(session.toJson())).toList();
    await prefs.setStringList(_chatHistoryKey, historyJson);
  }

  void _deleteChatSession(String id) {
    setState(() {
      _chatHistory.removeWhere((session) => session.id == id);
    });
    _saveChatHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Recent Chats'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _chatHistory.isEmpty
          ? const Center(
              child: Text(
                'No recent chats. Start a new one from the home screen!',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final session = _chatHistory[index];
                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      session.modelType == AiModelType.textWriter
                          ? Icons.text_fields
                          : session.modelType == AiModelType.imageGenerator
                              ? Icons.image
                              : session.modelType == AiModelType.codeTutor
                                  ? Icons.code
                                  : Icons.translate,
                      color: Colors.deepPurpleAccent,
                    ),
                    title: Text(
                      session.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      session.lastMessage.length > 50
                          ? '${session.lastMessage.substring(0, 50)}...'
                          : session.lastMessage,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () async {
                      Widget targetScreen;
                      switch (session.modelType) {
                        case AiModelType.textWriter:
                          targetScreen = TextWriterChatScreen(session: session);
                          break;
                        case AiModelType.imageGenerator:
                          targetScreen = ImageGeneratorChatScreen(session: session);
                          break;
                        case AiModelType.codeTutor:
                          targetScreen = CodeTutorChatScreen(session: session);
                          break;
                        case AiModelType.translator:
                          targetScreen = TranslatorChatScreen(session: session);
                          break;
                      }

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => targetScreen,
                        ),
                      );
                      if (result != null && result is ChatSession) {
                        setState(() {
                          final existingIndex = _chatHistory.indexWhere((s) => s.id == result.id);
                          if (existingIndex != -1) {
                            _chatHistory[existingIndex] = result;
                          }
                        });
                        _saveChatHistory();
                      }
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteChatSession(session.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

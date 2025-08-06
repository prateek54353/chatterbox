import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_session.dart';
import '../models/message.dart';
import '../models/ai_model.dart';
import 'package:chatterbox/screens/text_writer_chat_screen.dart';
import 'package:chatterbox/screens/image_generator_chat_screen.dart';
import 'package:chatterbox/screens/code_tutor_chat_screen.dart';
import 'package:chatterbox/screens/translator_chat_screen.dart';
import 'package:chatterbox/screens/general_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        // In a real app, you might want to log this error to a service
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

  Future<void> _navigateToChat(ChatSession? session, {AiModelType modelType = AiModelType.textWriter}) async {
    final newSession = session ??
        ChatSession(
          id: const Uuid().v4(),
          title: modelType.title, // Use the model title for the session
          modelType: modelType,
          messages: [Message(text: modelType.initialPrompt, isUser: false)], // Start with a system prompt
          lastMessage: 'New session started.',
          firstUserMessage: '', // User hasn't sent a message yet
        );

    Widget targetScreen;
    switch (modelType) {
      case AiModelType.textWriter:
        targetScreen = TextWriterChatScreen(session: newSession);
        break;
      case AiModelType.imageGenerator:
        targetScreen = ImageGeneratorChatScreen(session: newSession);
        break;
      case AiModelType.codeTutor:
        targetScreen = CodeTutorChatScreen(session: newSession);
        break;
      case AiModelType.translator:
        targetScreen = TranslatorChatScreen(session: newSession);
        break;
      case AiModelType.generalChat:
        targetScreen = GeneralChatScreen(session: newSession);
        break;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => targetScreen,
      ),
    );

    if (result != null && result is ChatSession) {
      // Only update history if there are more than the initial system message
      if (result.messages.length > 1) {
        final existingIndex = _chatHistory.indexWhere((s) => s.id == result.id);
        if (existingIndex != -1) {
          // Update existing session
          setState(() {
            _chatHistory[existingIndex] = result;
          });
        } else {
          // Add new session
          setState(() {
            _chatHistory.insert(0, result);
          });
        }
        _saveChatHistory();
      }
    }
  }

  Widget _buildAiCard(BuildContext context, {required String title, required String description, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color.withAlpha(38),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(64),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 20,
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF1C1C1E),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  'Chatterbox Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white70),
                title: const Text('About', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.pushNamed(context, '/about');
                },
              ),

              const Divider(color: Colors.white24),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.white70),
                title: const Text('Exit', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Show a confirmation dialog before exiting
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Exit Chatterbox?'),
                        content: const Text('Are you sure you want to exit Chatterbox?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              Navigator.pop(context); // Close the app
                            },
                            child: const Text('Exit'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80), // Padding to avoid overlap with the pill widget
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Hero Banner
                  Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
                        
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 16, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Chatterbox', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 12),
                        Text('Create, explore, be inspired.\nYour all-in-one AI assistant.', style: TextStyle(fontSize: 18, color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // AI Tools Grid
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildAiCard(context, title: 'AI Text Writer', description: 'Start a new conversation', icon: Icons.text_fields, color: Colors.deepPurpleAccent, onTap: () => _navigateToChat(null, modelType: AiModelType.textWriter)),
                      _buildAiCard(context, title: 'AI Image Generator', description: 'Create a new image', icon: Icons.image, color: Colors.pinkAccent, onTap: () => _navigateToChat(null, modelType: AiModelType.imageGenerator)),
                      _buildAiCard(context, title: 'AI Code Tutor', description: 'Learn to code', icon: Icons.code, color: Colors.orangeAccent, onTap: () => _navigateToChat(null, modelType: AiModelType.codeTutor)),
                      _buildAiCard(context, title: 'AI Translator', description: 'Translate any language', icon: Icons.translate, color: Colors.lightBlueAccent, onTap: () => _navigateToChat(null, modelType: AiModelType.translator)),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Recent Chats Pill
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/recent_chats'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[850]?.withAlpha(230),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history, color: Colors.white70, size: 20),
                          SizedBox(width: 8),
                          Text('Recent Chats', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  // New Chat FAB
                  FloatingActionButton(
                    onPressed: () => _navigateToChat(null, modelType: AiModelType.generalChat), // Default to general chat
                    backgroundColor: Colors.deepPurpleAccent,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
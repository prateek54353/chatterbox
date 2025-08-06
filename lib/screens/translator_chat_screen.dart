import 'package:flutter/material.dart';
import 'package:chatterbox/models/chat_session.dart';
import 'package:chatterbox/models/message.dart';
import 'package:chatterbox/models/ai_model.dart';
import 'package:chatterbox/services/ai_translator_service.dart';
import 'package:chatterbox/widgets/typing_indicator.dart';
import 'package:chatterbox/widgets/chat_bubble.dart';

class TranslatorChatScreen extends StatefulWidget {
  final ChatSession session;

  const TranslatorChatScreen({super.key, required this.session});

  @override
  State<TranslatorChatScreen> createState() => _TranslatorChatScreenState();
}

class _TranslatorChatScreenState extends State<TranslatorChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiTranslatorService _aiService = AiTranslatorService();
  bool _isTyping = false;

  // A comprehensive, alphabetized list of 100 languages.
  final List<String> _languages = [
    'Afrikaans', 'Albanian', 'Amharic', 'Arabic', 'Armenian', 'Azerbaijani', 'Basque',
    'Belarusian', 'Bengali', 'Bosnian', 'Bulgarian', 'Burmese', 'Catalan', 'Cebuano',
    'Chichewa', 'Chinese', 'Corsican', 'Croatian', 'Czech', 'Danish', 'Dutch',
    'English', 'Esperanto', 'Estonian', 'Filipino', 'Finnish', 'French', 'Frisian',
    'Galician', 'Georgian', 'German', 'Greek', 'Gujarati', 'Haitian Creole', 'Hausa',
    'Hawaiian', 'Hebrew', 'Hindi', 'Hmong', 'Hungarian', 'Icelandic', 'Igbo', 'Indonesian',
    'Irish', 'Italian', 'Japanese', 'Javanese', 'Kannada', 'Kazakh', 'Khmer', 'Korean',
    'Kurdish', 'Kyrgyz', 'Lao', 'Latin', 'Latvian', 'Lithuanian', 'Luxembourgish',
    'Macedonian', 'Malagasy', 'Malay', 'Malayalam', 'Maltese', 'Maori', 'Marathi',
    'Mongolian', 'Nepali', 'Norwegian', 'Pashto', 'Persian', 'Polish', 'Portuguese',
    'Punjabi', 'Romanian', 'Russian', 'Samoan', 'Scots Gaelic', 'Serbian', 'Sesotho',
    'Shona', 'Sindhi', 'Sinhala', 'Slovak', 'Slovenian', 'Somali', 'Spanish', 'Sundanese',
    'Swahili', 'Swedish', 'Tajik', 'Tamil', 'Telugu', 'Thai', 'Turkish', 'Ukrainian',
    'Urdu', 'Uzbek', 'Vietnamese', 'Welsh', 'Xhosa', 'Yiddish', 'Yoruba', 'Zulu'
  ];
  
  late String _selectedTargetLanguage;

  @override
  void initState() {
    super.initState();
    _selectedTargetLanguage = _languages.first;
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();
    final userMessage = Message(text: text, isUser: true);

    setState(() {
      widget.session.messages.add(userMessage);
      _isTyping = true;
    });

    _scrollToBottom();
    await _getAiResponse(text);
  }

  Future<void> _getAiResponse(String prompt) async {
    try {
      final aiResponse = await _aiService.getResponse(prompt, _selectedTargetLanguage);
      setState(() {
        widget.session.messages.add(aiResponse);
        _isTyping = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isTyping = false;
        widget.session.messages.add(Message(
          text: "Sorry, I couldn't connect to the AI service. Please check your connection and try again.",
          isUser: false,
        ));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.session.modelType.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.session.messages.isNotEmpty) {
              final lastMessage = widget.session.messages.last;
              widget.session.updateLastMessage(lastMessage.text ?? (lastMessage.imageUrl != null ? 'Image created' : 'No content'));
            }
            Navigator.pop(context, widget.session);
          },
        ),
      ),
      body: Column(
        children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                itemCount: widget.session.messages.length,
                itemBuilder: (context, index) {
                  final message = widget.session.messages[index];
                  return ChatBubble(
                    text: message.text,
                    imageUrl: message.imageUrl,
                    isUser: message.isUser,
                    onImageTap: (imageUrl) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            backgroundColor: Colors.black,
                            appBar: AppBar(
                              backgroundColor: Colors.black,
                              iconTheme: const IconThemeData(color: Colors.white),
                            ),
                            body: Center(
                              child: Image.network(imageUrl),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (_isTyping) const TypingIndicator(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.black,
              child: Row(
                children: [
                  const Text('Translate to:', style: TextStyle(color: Colors.white70)),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedTargetLanguage,
                    dropdownColor: Colors.grey[850],
                    style: const TextStyle(color: Colors.white),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTargetLanguage = newValue!;
                      });
                    },
                    items: _languages.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              color: Colors.black,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _handleSubmitted,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Send a message...",
                        hintStyle: TextStyle(color: Colors.white.withAlpha(153)),
                        filled: true,
                        fillColor: Colors.grey[850],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.deepPurpleAccent),
                      onPressed: () => _handleSubmitted(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
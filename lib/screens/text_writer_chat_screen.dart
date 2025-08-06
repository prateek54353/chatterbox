import 'package:flutter/material.dart';
import 'package:chatterbox/models/chat_session.dart';
import 'package:chatterbox/models/message.dart';
import 'package:chatterbox/models/ai_model.dart';
import 'package:chatterbox/services/ai_text_writer_service.dart';
import 'package:chatterbox/widgets/typing_indicator.dart';
import 'package:chatterbox/widgets/chat_bubble.dart';

class TextWriterChatScreen extends StatefulWidget {
  final ChatSession session;

  const TextWriterChatScreen({super.key, required this.session});

  @override
  State<TextWriterChatScreen> createState() => _TextWriterChatScreenState();
}

class _TextWriterChatScreenState extends State<TextWriterChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiTextWriterService _aiService = AiTextWriterService();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    if (widget.session.messages.length == 1 && !widget.session.messages.first.isUser) {
      _getAiResponse(widget.session.messages.first.text!);
    }
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
      final aiResponse = await _aiService.getResponse(prompt);
      setState(() {
        widget.session.messages.add(aiResponse);
        _isTyping = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isTyping = false;
        widget.session.messages.add(Message(
          text: '''Sorry, I couldn't connect to the AI service. Please check your connection and try again.''',
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
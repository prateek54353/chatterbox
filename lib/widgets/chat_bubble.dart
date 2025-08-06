import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatBubble extends StatelessWidget {
  static const String greeting = 'Hi there! Ask me anything.';
  final String? text;
  final String? imageUrl;
  final bool isUser;
  final void Function(String imageUrl)? onImageTap;

  const ChatBubble({super.key, this.text, this.imageUrl, required this.isUser, this.onImageTap});

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isUser ? Colors.blue[700] : Colors.grey[800];
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Material(
            color: bubbleColor,
            borderRadius: radius,
            child: InkWell(
              borderRadius: radius,
              onTap: imageUrl != null && onImageTap != null
                  ? () => onImageTap!(imageUrl!)
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: align,
                  children: [
                    if (imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl!,
                          height: 180,
                          width: 240,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (text != null && !isUser && text != ChatBubble.greeting)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                text!,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, color: Colors.white70, size: 20),
                              tooltip: 'Copy',
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: text!));
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Copied to clipboard!')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    if (text != null && isUser)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          text!,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


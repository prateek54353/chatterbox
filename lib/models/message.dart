
class Message {
  final String? text;
  final String? imageUrl;
  final bool isUser;

  Message({this.text, this.imageUrl, required this.isUser})
      : assert(text != null || imageUrl != null);

  Map<String, dynamic> toJson() => {
        'text': text,
        'imageUrl': imageUrl,
        'isUser': isUser,
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      imageUrl: json['imageUrl'],
      isUser: json['isUser'],
    );
  }
}

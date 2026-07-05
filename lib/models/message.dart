import 'user.dart';

class Message {
  final String id;
  final String chatId;
  final User sender;
  final String content;
  final String type;
  final String? fileUrl;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.content,
    required this.type,
    this.fileUrl,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      chatId: json['chat'],
      sender: User.fromJson(json['sender']),
      content: json['content'],
      type: json['type'] ?? 'text',
      fileUrl: json['fileUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

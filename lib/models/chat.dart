import 'user.dart';

class Chat {
  final String id;
  final bool isGroup;
  final List<User> participants;
  final String? name;
  final String type;

  Chat({
    required this.id,
    required this.isGroup,
    required this.participants,
    this.name,
    required this.type,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      isGroup: json['isGroup'] ?? false,
      participants: (json['participants'] as List)
          .map((p) => User.fromJson(p))
          .toList(),
      name: json['name'],
      type: json['type'] ?? 'private',
    );
  }
}

enum MessageType { text, image, voice }

class ChatMessage {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isUser;
  final MessageType type;
  final String? backgroundImage;
  final String? avatar;

  ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isUser,
    this.type = MessageType.text,
    this.backgroundImage,
    this.avatar,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isUser: json['is_user'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      backgroundImage: json['background_image'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'is_user': isUser,
      'type': type.toString().split('.').last,
      'background_image': backgroundImage,
      'avatar': avatar,
    };
  }
}

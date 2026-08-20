import 'package:kasagardem/chatbot/models/garden_chat_response_model.dart';

class ChatMessage {
  final String id;
  final String role;
  final String text;
  final String? imagePath;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isTyping;
  final bool animateIn;

  ChatMessage({
    required this.id,
    this.role = 'user',
    this.text = '',
    this.imagePath,
    this.imageUrl,
    this.isTyping = false,
    this.animateIn = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isUser => role.toLowerCase() == 'user';

  bool get hasText => text.trim().isNotEmpty;

  bool get hasLocalImage => imagePath != null && imagePath!.isNotEmpty;

  bool get hasNetworkImage => imageUrl != null && imageUrl!.isNotEmpty;

  bool get hasImage => hasLocalImage || hasNetworkImage;

  factory ChatMessage.fromTurn(GardenChatTurn turn) {
    return ChatMessage(
      id: '${turn.role}_${turn.createdAt?.microsecondsSinceEpoch ?? DateTime.now().microsecondsSinceEpoch}',
      role: turn.role ?? 'assistant',
      text: turn.content ?? '',
      imageUrl: turn.imageUrl,
      createdAt: turn.createdAt,
    );
  }

  ChatMessage copyWith({
    String? id,
    String? role,
    String? text,
    String? imagePath,
    String? imageUrl,
    DateTime? createdAt,
    bool? isTyping,
    bool? animateIn,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isTyping: isTyping ?? this.isTyping,
      animateIn: animateIn ?? this.animateIn,
    );
  }
}

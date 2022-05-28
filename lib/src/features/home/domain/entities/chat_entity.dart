import 'package:talking/src/core/domain/entities/app_entities.dart';

class ChatEntity {
  final String friend;
  final MessageEntity message;
  final int unread;

  ChatEntity({
    required this.friend,
    required this.message,
    required this.unread,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatEntity && other.friend == friend && other.message == message && other.unread == unread;
  }

  @override
  int get hashCode => friend.hashCode ^ message.hashCode ^ unread.hashCode;

  @override
  String toString() => 'ChatEntity(friend: $friend, messages: $message, unread: $unread)';

  ChatEntity copyWith({
    String? friend,
    MessageEntity? message,
    int? unread,
  }) {
    return ChatEntity(
      friend: friend ?? this.friend,
      message: message ?? this.message,
      unread: unread ?? this.unread,
    );
  }
}

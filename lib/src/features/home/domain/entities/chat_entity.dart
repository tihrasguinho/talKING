import 'package:flutter/foundation.dart';

import 'package:talking/src/features/home/domain/entities/message_entity.dart';

class ChatEntity {
  final String friend;
  final List<MessageEntity> messages;

  ChatEntity({
    required this.friend,
    required this.messages,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatEntity && other.friend == friend && listEquals(other.messages, messages);
  }

  @override
  int get hashCode => friend.hashCode ^ messages.hashCode;

  @override
  String toString() => 'ChatEntity(friend: $friend, messages: $messages)';

  ChatEntity copyWith({
    String? friend,
    List<MessageEntity>? messages,
  }) {
    return ChatEntity(
      friend: friend ?? this.friend,
      messages: messages ?? this.messages,
    );
  }
}

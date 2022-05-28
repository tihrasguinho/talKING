import 'package:talking/src/core/domain/entities/app_entities.dart';

class LastMessageEntity {
  final UserEntity user;
  final MessageEntity message;

  LastMessageEntity({
    required this.user,
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LastMessageEntity && other.user == user && other.message == message;
  }

  @override
  int get hashCode => user.hashCode ^ message.hashCode;

  @override
  String toString() => 'LastMessageEntity(user: $user, message: $message)';

  LastMessageEntity copyWith({
    UserEntity? user,
    MessageEntity? message,
  }) {
    return LastMessageEntity(
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }
}

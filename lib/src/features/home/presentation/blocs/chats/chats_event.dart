import 'package:talking/src/features/home/domain/entities/message_entity.dart';

abstract class ChatsEvent {}

class InitialChatsEvent extends ChatsEvent {}

class HiveChatsEvent extends ChatsEvent {}

class LoadChatsEvent extends ChatsEvent {
  final List<MessageEntity> messages;

  LoadChatsEvent(this.messages);
}

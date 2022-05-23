import 'package:talking/src/features/home/domain/entities/message_entity.dart';

abstract class MessagesState {
  final List<MessageEntity> messages;

  MessagesState(this.messages);
}

class SuccessMessagesState extends MessagesState {
  SuccessMessagesState(super.messages);
}

class ErrorMessagesState extends MessagesState {
  final String error;

  ErrorMessagesState(this.error) : super([]);
}

class LoadingMessagesState extends MessagesState {
  LoadingMessagesState() : super([]);
}

class InitialMessagesState extends MessagesState {
  InitialMessagesState() : super([]);
}

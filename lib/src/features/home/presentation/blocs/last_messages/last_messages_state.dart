import 'package:talking/src/features/home/domain/entities/last_message_entity.dart';

abstract class LastMessagesState {
  final List<LastMessageEntity> messages;

  LastMessagesState(this.messages);
}

class SuccessLastMessagesState extends LastMessagesState {
  SuccessLastMessagesState(super.messages);
}

class ErrorLastMessagesState extends LastMessagesState {
  final String error;

  ErrorLastMessagesState(this.error) : super([]);
}

class LoadingLastMessagesState extends LastMessagesState {
  LoadingLastMessagesState() : super([]);
}

class InitialLastMessagesState extends LastMessagesState {
  InitialLastMessagesState() : super([]);
}

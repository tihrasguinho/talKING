import 'package:talking/src/features/home/domain/entities/chat_entity.dart';

abstract class ChatsState {
  final List<ChatEntity> chats;

  ChatsState(this.chats);
}

class InitialChatsState extends ChatsState {
  InitialChatsState() : super([]);
}

class SuccessChatsState extends ChatsState {
  SuccessChatsState(super.chats);
}

class LoadingChatsState extends ChatsState {
  LoadingChatsState() : super([]);
}

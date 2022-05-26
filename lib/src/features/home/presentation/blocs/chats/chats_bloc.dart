import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talking/src/features/home/domain/entities/chat_entity.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';

class ChatsBloc extends ValueNotifier<List<ChatEntity>> {
  final hive = Hive.box('app');

  ChatsBloc() : super([]);

  void populate(List<MessageEntity> messages) async {
    final uid = hive.get('uid');

    final friends = messages.map((e) => e.from == uid ? e.to : e.from).toSet().toList();

    final chats = <ChatEntity>[];

    for (var friend in friends) {
      final filtered = messages.where((e) => e.from == friend || e.to == friend).toList();

      filtered.sort((a, b) => b.time.compareTo(a.time));

      final chat = ChatEntity(friend: friend, messages: filtered);

      chats.add(chat);
    }

    chats.sort((a, b) => b.messages.first.time.compareTo(a.messages.first.time));

    value = chats;
  }
}

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talking/src/core/data/dtos/app_dtos.dart';
import 'package:talking/src/features/home/domain/entities/chat_entity.dart';
import 'package:talking/src/features/home/presentation/blocs/chats/chats_event.dart';
import 'package:talking/src/features/home/presentation/blocs/chats/chats_state.dart';

class ChatsBloc {
  final _controller = BehaviorSubject<ChatsEvent>.seeded(InitialChatsEvent());

  void emit(ChatsEvent event) => _controller.sink.add(event);

  Stream<ChatsState> get stream => _controller.stream.switchMap(_mapEventToState);

  Stream<ChatsState> _mapEventToState(ChatsEvent event) async* {
    if (event is InitialChatsEvent) {
      yield InitialChatsState();
    } else if (event is LoadChatsEvent) {
      yield LoadingChatsState();

      final messages = event.messages;

      final uid = Hive.box('app').get('uid');

      final friends = messages.map((e) => e.from == uid ? e.to : e.from).toSet().toList();

      final chats = <ChatEntity>[];

      for (var friend in friends) {
        final filtered = messages.where((e) => e.from == friend || e.to == friend).toList();

        filtered.sort((a, b) => b.time.compareTo(a.time));

        final unread = filtered.where((e) => e.from == friend && e.seen == false).toList();

        await Hive.box('app').put(friend, filtered.map((e) => e.toJson()).toList());

        final chat = ChatEntity(
          friend: friend,
          message: filtered.first,
          unread: unread.length,
        );

        chats.add(chat);
      }

      chats.sort((a, b) => b.message.time.compareTo(a.message.time));

      yield SuccessChatsState(chats);
    }
  }

  void dispose() {
    _controller.close();
  }
}

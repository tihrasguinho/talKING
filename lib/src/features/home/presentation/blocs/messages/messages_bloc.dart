import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talking/src/features/home/data/dtos/message_dto.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_event.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_state.dart';

class MessagesBloc {
  final _streamController = BehaviorSubject<MessagesEvent>.seeded(InitialMessagesEvent(''));

  void emit(MessagesEvent event) => _streamController.sink.add(event);

  Stream<MessagesState> get stream => _streamController.stream.switchMap(_mapEventToState);

  Stream<MessagesState> _mapEventToState(MessagesEvent event) async* {
    if (event is LoadMessagesEvent) {
      yield LoadingMessagesState();

      final textsDocs = event.docs.where((e) => e.data()['type'] == 'text').toList();

      final textsMessages = textsDocs.map((e) => MessageDto.fromFirestore(e)).toList();

      final imagesDocs = event.docs.where((e) => e.data()['type'] == 'image').toList();

      final imagesMessages = imagesDocs.map((e) => MessageDto.fromFirestore(e)).toList();

      // final audiosDocs = event.docs.where((e) => e.data()['type'] == 'audio').toList();

      // final videosDocs = event.docs.where((e) => e.data()['type'] == 'video').toList();

      final messages = <MessageEntity>[];

      messages.addAll(textsMessages);

      messages.addAll(imagesMessages);

      messages.sort((a, b) => b.time.compareTo(a.time));

      yield SuccessMessagesState(messages);
    } else if (event is InitialMessagesEvent) {
      if (event.friendUid.isEmpty) {
        yield SuccessMessagesState([]);
      } else {
        final messages = Hive.box('app').containsKey(event.friendUid)
            ? Hive.box('app').get(event.friendUid) as List<String>
            : <String>[];

        yield SuccessMessagesState(messages.map((e) => MessageDto.fromJson(e)).toList());
      }
    }
  }

  void dispose() {
    _streamController.close();
  }
}

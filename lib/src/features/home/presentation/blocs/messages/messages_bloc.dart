import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:talking/src/features/home/data/dtos/message_dto.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_event.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_state.dart';

class MessagesBloc {
  final _streamController = BehaviorSubject<MessagesEvent>.seeded(InitialMessagesEvent());

  void emit(MessagesEvent event) => _streamController.sink.add(event);

  Stream<MessagesState> get stream => _streamController.stream.switchMap(_mapEventToState);

  Stream<MessagesState> _mapEventToState(MessagesEvent event) async* {
    if (event is LoadMessagesEvent) {
      yield LoadingMessagesState();

      final textsDocs = event.docs.where((e) => e.data()['type'] == 'text').toList();

      final textsMessages = textsDocs.map((e) => MessageDto.textFromFirestore(e)).toList();

      final imagesDocs = event.docs.where((e) => e.data()['type'] == 'image').toList();

      final imagesMessages = imagesDocs.map((e) => MessageDto.imageFromFirestore(e)).toList();

      // final audiosDocs = event.docs.where((e) => e.data()['type'] == 'audio').toList();

      // final videosDocs = event.docs.where((e) => e.data()['type'] == 'video').toList();

      final messages = <MessageEntity>[];

      messages.addAll(textsMessages);

      messages.addAll(imagesMessages);

      messages.sort((a, b) => b.time.compareTo(a.time));

      yield SuccessMessagesState(messages);
    } else if (event is InitialMessagesEvent) {
      yield SuccessMessagesState([]);
    }
  }

  void dispose() {
    _streamController.close();
  }
}

// List<MessageEntity> _filtering(List<MessageEntity> list) {
//   final data = <String, MessageEntity>{};

//   for (var item in list) {
//     data[item.id] = item;
//   }

//   return data.values.toList();
// }

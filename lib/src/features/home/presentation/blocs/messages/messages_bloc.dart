import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:talking/src/features/home/data/dtos/message_dto.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_event.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_state.dart';

// class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
//   final IGetMessagesUsecase _getMessagesUsecase;

//   MessagesBloc(this._getMessagesUsecase) : super(InitialMessagesState()) {
//     on<FetchMessagesEvent>((event, emit) async {
//       emit(LoadingMessagesState());

//       final result = await _getMessagesUsecase(event.friendUid);

//       if (result.isRight()) {
//         emit(SuccessMessagesState(result.getOrElse(() => [])));
//       } else {
//         final exception = result.fold((l) => l, (r) => null) as AppException;

//         emit(ErrorMessagesState(exception.error));
//       }
//     });

//     on<LoadMessagesEvent>((event, emit) {
//       final current = state is SuccessMessagesState ? state.messages : <MessageEntity>[];

//       final messages = <MessageEntity>[...current];

//       final texts = event.docs.where((e) => e.data()['type'] == 'text').toList();

//       messages.addAll(texts.map((e) => MessageDto.textFromFirestore(e)).toList());

//       messages.sort((a, b) => b.time.compareTo(a.time));

//       emit(SuccessMessagesState(messages.toSet().toList()));
//     });
//   }
// }

class MessagesBloc {
  final _state = <MessageEntity>[];

  final _streamController = StreamController<MessagesEvent>.broadcast();

  Sink<MessagesEvent> get input => _streamController.sink;

  Stream<MessagesState> get output => _streamController.stream.switchMap(_switchEventToMap);

  Stream<MessagesState> _switchEventToMap(MessagesEvent event) async* {
    if (event is LoadMessagesEvent) {
      yield LoadingMessagesState();

      final textsDocs = event.docs.where((e) => e.data()['type'] == 'text').toList();

      final textsMessages = textsDocs.map((e) => MessageDto.textFromFirestore(e)).toList();

      // final imagesDocs = event.docs.where((e) => e.data()['type'] == 'image').toList();

      // final audiosDocs = event.docs.where((e) => e.data()['type'] == 'audio').toList();

      // final videosDocs = event.docs.where((e) => e.data()['type'] == 'video').toList();

      final messages = <MessageEntity>[..._state];

      messages.addAll(textsMessages);

      messages.sort((a, b) => b.time.compareTo(a.time));

      _state.clear();

      _state.addAll(messages);

      yield SuccessMessagesState(_filtering(_state));
    }
  }
}

List<MessageEntity> _filtering(List<MessageEntity> list) {
  final data = <String, MessageEntity>{};

  for (var item in list) {
    data[item.id] = item;
  }

  return data.values.toList();
}

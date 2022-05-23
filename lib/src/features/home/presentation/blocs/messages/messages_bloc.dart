import 'package:bloc/bloc.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/data/dtos/message_dto.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/domain/usecases/get_messages_usecase/get_messages_usecase.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_event.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final IGetMessagesUsecase _getMessagesUsecase;

  MessagesBloc(this._getMessagesUsecase) : super(InitialMessagesState()) {
    on<FetchMessagesEvent>((event, emit) async {
      emit(LoadingMessagesState());

      final result = await _getMessagesUsecase(event.friendUid);

      if (result.isRight()) {
        emit(SuccessMessagesState(result.getOrElse(() => [])));
      } else {
        final exception = result.fold((l) => l, (r) => null) as AppException;

        emit(ErrorMessagesState(exception.error));
      }
    });

    on<LoadMessagesEvent>((event, emit) {
      final current = state is SuccessMessagesState ? state.messages : <MessageEntity>[];

      final messages = <MessageEntity>[...current];

      final texts = event.docs.where((e) => e.data()['type'] == 'text').toList();

      messages.addAll(texts.map((e) => MessageDto.textFromFirestore(e)).toList());

      messages.sort((a, b) => b.time.compareTo(a.time));

      emit(SuccessMessagesState(messages.toSet().toList()));
    });
  }
}

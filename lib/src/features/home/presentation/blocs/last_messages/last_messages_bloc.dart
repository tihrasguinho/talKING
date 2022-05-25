import 'package:flutter/foundation.dart';
import 'package:talking/src/features/home/presentation/blocs/last_messages/last_messages_event.dart';
import 'package:talking/src/features/home/presentation/blocs/last_messages/last_messages_state.dart';

class LastMessagesBloc extends ValueNotifier<LastMessagesState> {
  LastMessagesBloc() : super(InitialLastMessagesState());

  void emit(LastMessagesEvent event) async {
    if (event is LoadLasMessagesEvent) {}
  }
}

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/usecases/get_friends_usecase/get_friends_usecase.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_event.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_state.dart';

class FriendsBloc extends ValueNotifier<FriendsState> {
  final IGetFriendsUsecase _getFriendsUsecase;

  FriendsBloc(this._getFriendsUsecase) : super(InitialFriendsState()) {
    emit(FetchFriendsEvent());
  }

  void emit(FriendsEvent event) async {
    if (event is FetchFriendsEvent) {
      log('FetchFriendsEvent');

      value = LoadingFriendsState();

      final result = await _getFriendsUsecase();

      if (result.isRight()) {
        final friends = result.getOrElse(() => []);

        value = SuccessFriendsState(friends);
      } else {
        final exception = result.fold((l) => l, (r) => null) as AppException;

        value = ErrorFriendsState(exception.error);
      }
    }
  }
}

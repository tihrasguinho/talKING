import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/usecases/get_current_user_usecase/get_current_user_usecase.dart';
import 'package:talking/src/features/home/presentation/blocs/current_user/current_user_event.dart';
import 'package:talking/src/features/home/presentation/blocs/current_user/current_user_state.dart';

class CurrentUserBloc extends ValueNotifier<CurrentUserState> {
  final IGetCurrentUserUsecase _getCurrentUserUsecase;

  CurrentUserBloc(this._getCurrentUserUsecase) : super(LoadingCurrentUserState()) {
    emit(FetchCurrentUser());
  }

  void emit(CurrentUserEvent event) async {
    if (event is FetchCurrentUser) {
      log('FetchCurrentUserEvent');

      value = LoadingCurrentUserState();

      final result = await _getCurrentUserUsecase();

      if (result.isRight()) {
        final user = result.fold((l) => null, (r) => r) as UserEntity;

        value = SuccessCurrentUserState(user);
      } else {
        final exception = result.fold((l) => l, (r) => null) as AppException;

        value = ErrorCurrentUserState(exception.error);
      }
    }
  }
}

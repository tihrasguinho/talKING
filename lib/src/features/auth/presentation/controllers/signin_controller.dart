import 'dart:developer';

import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/domain/entities/user_entity.dart';
import 'package:talking/src/features/auth/domain/usecases/signin_usecase/signin_usecase.dart';

class SigninController {
  final ISigninUsecase _signinUsecase;

  SigninController(this._signinUsecase);

  Future<void> signIn(String email, String password) async {
    final result = await _signinUsecase(email, password);

    if (result.isRight()) {
      final user = result.fold((l) => null, (r) => r) as UserEntity;

      log(user.toString(), name: 'signInSuccess');
    } else {
      final exception = result.fold((l) => l, (r) => null) as AppException;

      log(exception.error, name: 'signInError');
    }
  }
}

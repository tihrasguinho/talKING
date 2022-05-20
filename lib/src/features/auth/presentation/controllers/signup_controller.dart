import 'dart:developer';

import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/domain/entities/user_entity.dart';
import 'package:talking/src/features/auth/domain/usecases/signup_usecase/signup_usecase.dart';

class SignupController {
  final ISignupUsecase _signupUsecase;

  SignupController(this._signupUsecase);

  Future<void> signUp(String name, String username, String email, String password) async {
    final result = await _signupUsecase(name, username, email, password);

    if (result.isRight()) {
      final user = result.fold((l) => null, (r) => r) as UserEntity;

      log(user.toString(), name: 'signUpSuccess');
    } else {
      final exception = result.fold((l) => l, (r) => null) as AppException;

      log(exception.error, name: 'signUpError');
    }
  }
}

import 'dart:developer';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/others/app_snackbars.dart';
import 'package:talking/src/features/auth/domain/usecases/reset_password_usecase/reset_password_usecase.dart';

class ResetPasswordController {
  final IResetPasswordUsecase _passwordUsecase;

  ResetPasswordController(this._passwordUsecase);

  Future<void> resetPassword(String email) async {
    final result = await _passwordUsecase(email);

    if (result.isRight()) {
      final data = result.fold((l) => null, (r) => r) as String;

      log(data, name: 'resetPassword');

      AppSnackbars.success(data);

      Modular.to.navigate('/');
    } else {
      final exception = result.fold((l) => l, (r) => null) as AppException;

      log(exception.error, name: 'resetPasswordError');

      AppSnackbars.error(exception.error);
    }
  }
}

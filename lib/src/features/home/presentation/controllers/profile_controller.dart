import 'dart:developer';

import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/usecases/get_current_user_usecase/get_current_user_usecase.dart';

class ProfileController {
  final IGetCurrentUserUsecase _getCurrentUserUsecase;

  ProfileController(this._getCurrentUserUsecase);

  Future<UserEntity?> getCurrentUser() async {
    final result = await _getCurrentUserUsecase();

    if (result.isRight()) {
      return result.fold((l) => null, (r) => r) as UserEntity;
    } else {
      final exception = result.fold((l) => l, (r) => null) as AppException;

      log(exception.error, name: 'GetCurrentUserException');

      return null;
    }
  }
}

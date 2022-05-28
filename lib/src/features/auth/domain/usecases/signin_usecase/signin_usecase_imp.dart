import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';

class SigninUsecaseImp implements ISigninUsecase {
  final ISigninRepository _repository;

  SigninUsecaseImp(this._repository);

  @override
  Future<Either<AppException, UserEntity>> call(String email, String password) async {
    if (email.isEmpty) {
      return Left(AppException(error: 'Please type a valid email!'));
    }

    if (password.isEmpty) {
      return Left(AppException(error: 'Please type your password!'));
    }

    return await _repository(email, password);
  }
}

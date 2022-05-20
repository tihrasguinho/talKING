import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/domain/entities/user_entity.dart';
import 'package:talking/src/features/auth/domain/repositories/signin_repository.dart';
import 'package:talking/src/features/auth/domain/usecases/signin_usecase/signin_usecase.dart';

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

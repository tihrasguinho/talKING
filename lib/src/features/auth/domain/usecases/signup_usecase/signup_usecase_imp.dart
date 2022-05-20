import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/domain/entities/user_entity.dart';
import 'package:talking/src/features/auth/domain/repositories/signup_repository.dart';
import 'package:talking/src/features/auth/domain/usecases/signup_usecase/signup_usecase.dart';

class SignupUsecaseImp implements ISignupUsecase {
  final ISignupRepository _repository;

  SignupUsecaseImp(this._repository);

  @override
  Future<Either<AppException, UserEntity>> call(String name, String username, String email, String password) async {
    return await _repository(name, username, email, password);
  }
}

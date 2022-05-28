import 'package:dartz/dartz.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';
import 'package:talking/src/core/others/app_exception.dart';

class SignupUsecaseImp implements ISignupUsecase {
  final ISignupRepository _repository;

  SignupUsecaseImp(this._repository);

  @override
  Future<Either<AppException, UserEntity>> call(String name, String username, String email, String password) async {
    return await _repository(name, username, email, password);
  }
}

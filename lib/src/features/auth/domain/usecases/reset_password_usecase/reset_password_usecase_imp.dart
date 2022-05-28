import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';

class ResetPasswordUsecaseImp implements IResetPasswordUsecase {
  final IResetPasswordRepository _repository;

  ResetPasswordUsecaseImp(this._repository);

  @override
  Future<Either<AppException, String>> call(String email) async {
    if (email.isEmpty) {
      return Left(AppException(error: 'Please type your email!'));
    }

    return await _repository(email);
  }
}

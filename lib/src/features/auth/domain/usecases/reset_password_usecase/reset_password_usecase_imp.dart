import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/domain/repositories/reset_password_repository.dart';
import 'package:talking/src/features/auth/domain/usecases/reset_password_usecase/reset_password_usecase.dart';

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

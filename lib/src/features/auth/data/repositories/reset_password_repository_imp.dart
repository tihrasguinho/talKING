import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/data/datasources/reset_password_datasource/reset_password_datasource.dart';
import 'package:talking/src/features/auth/domain/repositories/reset_password_repository.dart';

class ResetPasswordRepositoryImp implements IResetPasswordRepository {
  final IResetPasswordDatasource _datasource;

  ResetPasswordRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, String>> call(String email) async {
    return await _datasource(email);
  }
}

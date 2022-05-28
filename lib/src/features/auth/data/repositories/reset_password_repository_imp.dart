import 'package:dartz/dartz.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/others/app_exception.dart';

class ResetPasswordRepositoryImp implements IResetPasswordRepository {
  final IResetPasswordDatasource _datasource;

  ResetPasswordRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, String>> call(String email) async {
    return await _datasource(email);
  }
}

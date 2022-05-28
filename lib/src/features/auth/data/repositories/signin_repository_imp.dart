import 'package:dartz/dartz.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';

class SigninRepositoryImp implements ISigninRepository {
  final ISigninDatasource _datasource;

  SigninRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, UserEntity>> call(String email, String password) async {
    return await _datasource(email, password);
  }
}

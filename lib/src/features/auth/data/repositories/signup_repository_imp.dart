import 'package:dartz/dartz.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';

class SignupRepositoryImp implements ISignupRepository {
  final ISignupDatasource _datasource;

  SignupRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, UserEntity>> call(String name, String username, String email, String password) async {
    return await _datasource(name, username, email, password);
  }
}

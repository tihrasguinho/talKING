import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/data/datasources/signup_datasource/signup_datasource.dart';
import 'package:talking/src/features/auth/domain/entities/user_entity.dart';
import 'package:talking/src/features/auth/domain/repositories/signup_repository.dart';

class SignupRepositoryImp implements ISignupRepository {
  final ISignupDatasource _datasource;

  SignupRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, UserEntity>> call(String name, String username, String email, String password) async {
    return await _datasource(name, username, email, password);
  }
}

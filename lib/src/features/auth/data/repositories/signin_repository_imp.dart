import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/data/datasources/signin_datasource/signin_datasource.dart';
import 'package:talking/src/features/auth/domain/entities/user_entity.dart';
import 'package:talking/src/features/auth/domain/repositories/signin_repository.dart';

class SigninRepositoryImp implements ISigninRepository {
  final ISigninDatasource _datasource;

  SigninRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, UserEntity>> call(String email, String password) async {
    return await _datasource(email, password);
  }
}

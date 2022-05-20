import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/domain/entities/user_entity.dart';

abstract class ISigninDatasource {
  Future<Either<AppException, UserEntity>> call(String email, String password);
}

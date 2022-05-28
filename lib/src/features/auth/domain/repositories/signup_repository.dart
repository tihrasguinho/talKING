import 'package:dartz/dartz.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/others/app_exception.dart';

abstract class ISignupRepository {
  Future<Either<AppException, UserEntity>> call(String name, String username, String email, String password);
}

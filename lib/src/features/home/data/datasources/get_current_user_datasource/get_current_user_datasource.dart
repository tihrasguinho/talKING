import 'package:dartz/dartz.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/others/app_exception.dart';

abstract class IGetCurrentUserDatasource {
  Future<Either<AppException, UserEntity>> call();
}

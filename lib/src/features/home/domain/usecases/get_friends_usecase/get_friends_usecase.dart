import 'package:dartz/dartz.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/others/app_exception.dart';

abstract class IGetFriendsUsecase {
  Future<Either<AppException, List<UserEntity>>> call();
}

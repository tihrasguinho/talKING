import 'package:dartz/dartz.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/others/app_exception.dart';

abstract class IDeleteMessageDatasource {
  Future<Either<AppException, bool>> call(MessageEntity message);
}

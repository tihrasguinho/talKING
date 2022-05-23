import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';

abstract class IGetMessagesDatasource {
  Future<Either<AppException, List<MessageEntity>>> call(String friendUid);
}

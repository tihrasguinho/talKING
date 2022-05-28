import 'package:dartz/dartz.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/params/send_message_params.dart';

abstract class ISendMessageDatasource {
  Future<Either<AppException, MessageEntity>> call(SendMessageParams params);
}

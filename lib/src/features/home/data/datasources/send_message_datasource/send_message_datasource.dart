import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/params/send_message_params.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';

abstract class ISendMessageDatasource {
  Future<Either<AppException, MessageEntity>> call(SendMessageParams params);
}

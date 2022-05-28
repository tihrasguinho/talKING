import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/params/send_message_params.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';

class SendMessageUsecaseImp implements ISendMessageUsecase {
  final ISendMessageRepository _repository;

  SendMessageUsecaseImp(this._repository);

  @override
  Future<Either<AppException, MessageEntity>> call(SendMessageParams params) async {
    return await _repository(params);
  }
}

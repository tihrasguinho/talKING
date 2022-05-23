import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/params/send_message_params.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/domain/repositories/send_message_repository.dart';
import 'package:talking/src/features/home/domain/usecases/send_message_usecase/send_message_usecase.dart';

class SendMessageUsecaseImp implements ISendMessageUsecase {
  final ISendMessageRepository _repository;

  SendMessageUsecaseImp(this._repository);

  @override
  Future<Either<AppException, MessageEntity>> call(SendMessageParams params) async {
    return await _repository(params);
  }
}

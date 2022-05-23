import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/domain/repositories/get_messages_repository.dart';
import 'package:talking/src/features/home/domain/usecases/get_messages_usecase/get_messages_usecase.dart';

class GetMessagesUsecaseImp implements IGetMessagesUsecase {
  final IGetMessagesRepository _repository;

  GetMessagesUsecaseImp(this._repository);

  @override
  Future<Either<AppException, List<MessageEntity>>> call(String friendUid) async {
    return await _repository(friendUid);
  }
}

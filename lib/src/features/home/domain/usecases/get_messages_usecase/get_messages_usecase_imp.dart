import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';

class GetMessagesUsecaseImp implements IGetMessagesUsecase {
  final IGetMessagesRepository _repository;

  GetMessagesUsecaseImp(this._repository);

  @override
  Future<Either<AppException, List<MessageEntity>>> call(String friendUid) async {
    return await _repository(friendUid);
  }
}

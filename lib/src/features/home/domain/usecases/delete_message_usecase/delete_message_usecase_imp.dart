import 'package:dartz/dartz.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';
import 'package:talking/src/core/others/app_exception.dart';

class DeleteMessageUsecaseImp implements IDeleteMessageUsecase {
  final IDeleteMessageRepository _repository;

  DeleteMessageUsecaseImp(this._repository);

  @override
  Future<Either<AppException, bool>> call(MessageEntity message) async {
    return await _repository(message);
  }
}

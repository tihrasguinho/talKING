import 'package:dartz/dartz.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';
import 'package:talking/src/core/others/app_exception.dart';

class UpdateTypingToUsecaseImp implements IUpdateTypingToUsecase {
  final IUpdateTypingToRepository _repository;

  UpdateTypingToUsecaseImp(this._repository);

  @override
  Future<Either<AppException, void>> call(String friendUid) async {
    return await _repository(friendUid);
  }
}

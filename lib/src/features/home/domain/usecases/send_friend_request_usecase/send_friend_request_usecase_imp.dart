import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';

class SendFriendRequestUsecaseImp implements ISendFriendRequestUsecase {
  final ISendFriendRequestRepository _repository;

  SendFriendRequestUsecaseImp(this._repository);

  @override
  Future<Either<AppException, String>> call(String friendUid) async {
    return await _repository(friendUid);
  }
}

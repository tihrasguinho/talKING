import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/repositories/send_friend_request_repository.dart';
import 'package:talking/src/features/home/domain/usecases/send_friend_request_usecase/send_friend_request_usecase.dart';

class SendFriendRequestUsecaseImp implements ISendFriendRequestUsecase {
  final ISendFriendRequestRepository _repository;

  SendFriendRequestUsecaseImp(this._repository);

  @override
  Future<Either<AppException, String>> call(String friendUid) async {
    return await _repository(friendUid);
  }
}

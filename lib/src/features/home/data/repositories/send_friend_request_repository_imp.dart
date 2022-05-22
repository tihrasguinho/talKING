import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/data/datasources/send_friend_request_datasource/send_friend_request_datasource.dart';
import 'package:talking/src/features/home/domain/repositories/send_friend_request_repository.dart';

class SendFriendRequestRepositoryImp implements ISendFriendRequestRepository {
  final ISendFriendRequestDatasource _datasource;

  SendFriendRequestRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, String>> call(String friendUid) async {
    return await _datasource(friendUid);
  }
}

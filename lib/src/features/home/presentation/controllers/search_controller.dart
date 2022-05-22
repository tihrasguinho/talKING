import 'dart:developer';

import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/usecases/send_friend_request_usecase/send_friend_request_usecase.dart';

class SearchController {
  final ISendFriendRequestUsecase _sendFriendRequestUsecase;

  SearchController(this._sendFriendRequestUsecase);

  Future<void> sendFriendRequest(String uid) async {
    final result = await _sendFriendRequestUsecase(uid);

    if (result.isRight()) {
      log(result.getOrElse(() => ''), name: 'SendFriendRequest');
    } else {
      final exception = result.fold((l) => l, (r) => null) as AppException;

      log(exception.error, name: 'SendFriendRequestException');
    }
  }
}

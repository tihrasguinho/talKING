import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/data/datasources/send_friend_request_datasource/send_friend_request_datasource.dart';

class SendFriendRequestFirebaseDatasourceImp implements ISendFriendRequestDatasource {
  @override
  Future<Either<AppException, String>> call(String friendUid) async {
    try {
      final auth = FirebaseAuth.instance;
      final functions = FirebaseFunctions.instance;

      final userUid = auth.currentUser?.uid;

      if (userUid == null) {
        return Left(AppException(error: 'User is not logged in!'));
      }

      final data = <String, dynamic>{
        'uid': friendUid,
      };

      final callable = await functions.httpsCallable('friendRequest').call(data);

      return Right(callable.data['message']);
    } on FirebaseException catch (e) {
      log(e.code);

      return Left(AppException(error: e.message!, stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

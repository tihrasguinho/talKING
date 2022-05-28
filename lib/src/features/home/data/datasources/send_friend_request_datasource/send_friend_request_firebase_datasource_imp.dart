import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/others/app_exception.dart';

class SendFriendRequestFirebaseDatasourceImp implements ISendFriendRequestDatasource {
  @override
  Future<Either<AppException, String>> call(String friendUid) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final userUid = auth.currentUser?.uid;

      if (userUid == null) {
        return Left(AppException(error: 'User is not logged in!'));
      }

      final data = <String, dynamic>{
        'from': userUid,
        'to': friendUid,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'status': 'awaiting',
      };

      final query = await firestore
          .collection('cl_requests')
          .where('from', isEqualTo: userUid)
          .where('to', isEqualTo: friendUid)
          .orderBy('created_at')
          .get();

      if (query.size > 0) {
        return Left(AppException(error: 'The friend request has already been sent!'));
      }

      await firestore.collection('cl_requests').add(data);

      return const Right('Friend request sent successfully!');
    } on FirebaseException catch (e) {
      log(e.code);

      return Left(AppException(error: e.message!, stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

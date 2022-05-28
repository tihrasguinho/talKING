import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/others/app_exception.dart';

class UpdateOnlineStatusFirebaseDatasourceImp implements IUpdateOnlineStatusDatasource {
  @override
  Future<Either<AppException, String>> call(AppLifecycleState state) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final uid = auth.currentUser?.uid;

      if (uid == null) {
        return Left(AppException(error: 'User is not logged in!'));
      }

      switch (state) {
        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
          {
            await firestore.collection('cl_users').doc(uid).update({
              'online': false,
            });

            return const Right('Online: FALSE');
          }
        case AppLifecycleState.resumed:
          {
            await firestore.collection('cl_users').doc(uid).update({
              'online': true,
              'last_connection': Timestamp.now(),
            });

            return const Right('Online: TRUE');
          }
      }
    } on FirebaseException catch (e) {
      return Left(AppException(error: e.message!, stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

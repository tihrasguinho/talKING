import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/data/dtos/app_dtos.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/others/app_exception.dart';

class SignupFirebaseDatasourceImp implements ISignupDatasource {
  @override
  Future<Either<AppException, UserEntity>> call(String name, String username, String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final query = await firestore.collection('cl_users').where('username', isEqualTo: username).get();

      if (query.size > 0) {
        return Left(AppException(error: 'Username already in use!'));
      }

      final credential = await auth.createUserWithEmailAndPassword(email: email, password: password);

      final data = {
        'name': name,
        'username': username,
        'email': email,
        'image': '',
        'online': false,
        'created_at': Timestamp.now(),
      };

      await firestore.collection('cl_users').doc(credential.user!.uid).set(data);

      data['uid'] = credential.user!.uid;

      return Right(UserDto.fromMap(data));
    } on FirebaseException catch (e) {
      log(e.code);

      switch (e.code) {
        case 'weak-password':
          {
            return Left(AppException(error: 'Weak password, please try another!', stackTrace: e.stackTrace));
          }
        case 'email-already-in-use':
          {
            return Left(AppException(error: 'Email already in use!', stackTrace: e.stackTrace));
          }
        case 'invalid-email':
          {
            return Left(AppException(error: 'Invalid email!', stackTrace: e.stackTrace));
          }
        default:
          {
            return Left(AppException(error: 'Fail to create user, try again later!', stackTrace: e.stackTrace));
          }
      }
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

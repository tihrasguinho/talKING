import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/data/dtos/user_dto.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/data/datasources/signin_datasource/signin_datasource.dart';

class SigninFirebaseDatasourceImp implements ISigninDatasource {
  @override
  Future<Either<AppException, UserEntity>> call(String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final credential = await auth.signInWithEmailAndPassword(email: email, password: password);

      final query = await firestore.collection('cl_users').doc(credential.user!.uid).get();

      if (query.exists) {
        return Right(UserDto.fromFirestore(query));
      } else {
        return Left(AppException(error: 'Fail to sign in, try again later!'));
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          {
            return Left(AppException(error: 'User not found!', stackTrace: e.stackTrace));
          }
        case 'wrong-password':
          {
            return Left(AppException(error: 'Wrong password!', stackTrace: e.stackTrace));
          }
        case 'invalid-email':
          {
            return Left(AppException(error: 'Invalid email!', stackTrace: e.stackTrace));
          }
        default:
          {
            return Left(AppException(error: e.message!, stackTrace: e.stackTrace));
          }
      }
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

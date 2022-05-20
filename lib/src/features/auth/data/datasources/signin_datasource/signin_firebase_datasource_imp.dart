import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/data/dtos/user_dto.dart';
import 'package:talking/src/features/auth/domain/entities/user_entity.dart';
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
      return Left(AppException(error: e.message!, stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

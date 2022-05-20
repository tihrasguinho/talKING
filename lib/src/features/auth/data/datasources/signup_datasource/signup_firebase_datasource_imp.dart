import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/data/dtos/user_dto.dart';
import 'package:talking/src/features/auth/domain/entities/user_entity.dart';
import 'package:talking/src/features/auth/data/datasources/signup_datasource/signup_datasource.dart';

class SignupFirebaseDatasourceImp implements ISignupDatasource {
  @override
  Future<Either<AppException, UserEntity>> call(String name, String username, String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final credential = await auth.createUserWithEmailAndPassword(email: email, password: password);

      final data = {
        'name': name,
        'username': username,
        'email': email,
        'image': '',
        'created_at': Timestamp.now(),
      };

      await firestore.collection('cl_users').doc(credential.user!.uid).set(data);

      data['uid'] = credential.user!.uid;

      return Right(UserDto.fromMap(data));
    } on FirebaseException catch (e) {
      return Left(AppException(error: e.message ?? '', stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

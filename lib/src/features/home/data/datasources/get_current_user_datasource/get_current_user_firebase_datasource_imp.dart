import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/data/dtos/app_dtos.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/others/app_exception.dart';

class GetCurrentUserFirebaseDatasourceImp implements IGetCurrentUserDatasource {
  @override
  Future<Either<AppException, UserEntity>> call() async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final uid = auth.currentUser?.uid;

      if (uid == null) {
        return Left(AppException(error: 'User is not logged in!'));
      }

      final query = await firestore.collection('cl_users').doc(uid).get();

      if (!query.exists) {
        return Left(AppException(error: 'Fail to load user data!'));
      } else {
        return Right(UserDto.fromFirestore(query));
      }
    } on FirebaseException catch (e) {
      return Left(AppException(error: '${e.message}', stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/data/dtos/app_dtos.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/others/app_exception.dart';

class SearchUsersFirebaseDatasourceImp implements ISearchUsersDatasource {
  @override
  Future<Either<AppException, List<UserEntity>>> call(String query) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final email = auth.currentUser?.email;

      if (email == null) {
        return Left(AppException(error: 'User is not logged in!'));
      }

      final select = query.isEmpty
          ? await firestore.collection('cl_users').limit(10).where('email', isNotEqualTo: email).get()
          : await firestore.collection('cl_users').where('email', isNotEqualTo: email).get();

      final users = select.docs.map((e) => UserDto.fromFirestore(e)).toList();

      return Right(users.where((e) => e.username.startsWith(query)).toList());
    } on FirebaseException catch (e) {
      return Left(AppException(error: e.message!, stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

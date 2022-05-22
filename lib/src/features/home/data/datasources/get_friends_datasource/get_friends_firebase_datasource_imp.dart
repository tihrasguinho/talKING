import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/data/dtos/user_dto.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/features/home/data/datasources/get_friends_datasource/get_friends_datasource.dart';

class GetFriendsFirebaseDatasourceImp implements IGetFriendsDatasource {
  @override
  Future<Either<AppException, List<UserEntity>>> call() async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final uid = auth.currentUser?.uid;

      if (uid == null) {
        return Left(AppException(error: 'User is not logged in!'));
      }

      final query = await firestore.collection('cl_users').doc(uid).collection('cl_friends').get();

      final friends = <UserEntity>[];

      for (var doc in query.docs) {
        final friend = await firestore.collection('cl_users').doc(doc.id).get();

        friends.add(UserDto.fromFirestore(friend));
      }

      return Right(friends);
    } on FirebaseException catch (e) {
      return Left(AppException(error: e.message!, stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

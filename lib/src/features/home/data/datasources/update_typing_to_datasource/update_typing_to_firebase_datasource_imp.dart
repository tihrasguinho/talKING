import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/others/app_exception.dart';

class UpdateTypingToFirebaseDatasourceImp implements IUpdateTypingToDatasource {
  @override
  Future<Either<AppException, void>> call(String friendUid) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final uid = auth.currentUser?.uid;

      if (uid == null) {
        return Left(AppException(error: 'The user is not logged in!'));
      }

      await firestore.collection('cl_users').doc(uid).update({'typing_to': friendUid});

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(AppException(error: e.code, stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

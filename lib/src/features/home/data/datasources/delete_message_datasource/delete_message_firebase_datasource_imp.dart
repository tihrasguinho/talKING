import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/enums/message_type.dart';
import 'package:talking/src/core/others/app_exception.dart';

class DeleteMessageFirebaseDatasourceImp implements IDeleteMessageDatasource {
  @override
  Future<Either<AppException, bool>> call(MessageEntity message) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;
      final storage = FirebaseStorage.instance;

      final uid = auth.currentUser?.uid;

      if (uid == null) {
        return Left(AppException(error: 'The user is not logged in!'));
      }

      if (message.from != uid) {
        return Left(AppException(error: 'The user is not the owner of this message!'));
      }

      if (message.type == MessageType.image) {
        message as ImageMessageEntity;

        await storage.refFromURL(message.image).delete();
      }

      await firestore.collection('cl_messages').doc(message.id).delete();

      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(AppException(error: e.message!, stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

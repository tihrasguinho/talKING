import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/data/datasources/get_messages_datasource/get_messages_datasource.dart';
import 'package:talking/src/features/home/data/dtos/message_dto.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';

class GetMessagesFirebaseDatasourceImp implements IGetMessagesDatasource {
  @override
  Future<Either<AppException, List<MessageEntity>>> call(String friendUid) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final uid = auth.currentUser?.uid;

      if (uid == null) {
        return Left(AppException(error: 'User is not logged in!'));
      }

      final messages = <MessageEntity>[];

      final from = await firestore
          .collection('cl_messages')
          .where('from', isEqualTo: uid)
          .where('to', isEqualTo: friendUid)
          .get();

      final to = await firestore
          .collection('cl_messages')
          .where('from', isEqualTo: friendUid)
          .where('to', isEqualTo: uid)
          .get();

      messages.addAll(from.docs.map((e) => MessageDto.textFromFirestore(e)).toList());

      messages.addAll(to.docs.map((e) => MessageDto.textFromFirestore(e)).toList());

      return Right(messages);
    } on FirebaseException catch (e) {
      return Left(AppException(error: e.message!, stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

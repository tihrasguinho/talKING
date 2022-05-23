import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/enums/message_type.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/params/send_message_params.dart';
import 'package:talking/src/features/home/data/datasources/send_message_datasource/send_message_datasource.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';

class SendMessageFirebaseDatasourceImp implements ISendMessageDatasource {
  @override
  Future<Either<AppException, MessageEntity>> call(SendMessageParams params) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final uid = auth.currentUser?.uid;

      if (uid == null) {
        return Left(AppException(error: 'User is not logged in!'));
      }

      final time = Timestamp.now();

      switch (params.type) {
        case MessageType.text:
          {
            final message = <String, dynamic>{
              'message': params.message,
              'from': uid,
              'to': params.to,
              'image': null,
              'audio': null,
              'video': null,
              'type': params.type.desc,
              'time': time,
            };

            final doc = await firestore.collection('cl_messages').add(message);

            return Right(
              TextMessageEntity(
                id: doc.id,
                message: params.message,
                from: uid,
                to: params.to,
                type: params.type,
                time: DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch),
              ),
            );
          }
        case MessageType.image:
          {
            final message = <String, dynamic>{
              'message': params.message,
              'from': uid,
              'to': params.to,
              'image': null,
              'audio': null,
              'video': null,
              'type': params.type.desc,
              'time': time,
            };

            final doc = await firestore.collection('cl_messages').add(message);

            return Right(
              TextMessageEntity(
                id: doc.id,
                message: params.message,
                from: uid,
                to: params.to,
                type: params.type,
                time: DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch),
              ),
            );
          }
        case MessageType.audio:
          {
            final message = <String, dynamic>{
              'message': params.message,
              'from': uid,
              'to': params.to,
              'image': null,
              'audio': null,
              'video': null,
              'type': params.type.desc,
              'time': time,
            };

            final doc = await firestore.collection('cl_messages').add(message);

            return Right(
              TextMessageEntity(
                id: doc.id,
                message: params.message,
                from: uid,
                to: params.to,
                type: params.type,
                time: DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch),
              ),
            );
          }
        case MessageType.video:
          {
            final message = <String, dynamic>{
              'message': params.message,
              'from': uid,
              'to': params.to,
              'image': null,
              'audio': null,
              'video': null,
              'type': params.type.desc,
              'time': time,
            };

            final doc = await firestore.collection('cl_messages').add(message);

            return Right(
              TextMessageEntity(
                id: doc.id,
                message: params.message,
                from: uid,
                to: params.to,
                type: params.type,
                time: DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch),
              ),
            );
          }
        default:
          {
            final message = <String, dynamic>{
              'message': params.message,
              'from': uid,
              'to': params.to,
              'image': null,
              'audio': null,
              'video': null,
              'type': params.type.desc,
              'time': time,
            };

            final doc = await firestore.collection('cl_messages').add(message);

            return Right(
              TextMessageEntity(
                id: doc.id,
                message: params.message,
                from: uid,
                to: params.to,
                type: params.type,
                time: DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch),
              ),
            );
          }
      }
    } on FirebaseException catch (e) {
      return Left(AppException(error: e.message!, stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}

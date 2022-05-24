import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      final storage = FirebaseStorage.instance;

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
            final sufix = params.image.split('/').last.split('.').last.toUpperCase();

            final name = '$uid-${DateTime.now().toUtc().toIso8601String()}.$sufix';

            final upload = await storage.ref().child(uid).child(name).putFile(File(params.image));

            final url = await upload.ref.getDownloadURL();

            final message = <String, dynamic>{
              'from': uid,
              'to': params.to,
              'image': url,
              'aspect_ratio': params.aspectRatio,
              'type': params.type.desc,
              'time': time,
            };

            final doc = await firestore.collection('cl_messages').add(message);

            return Right(
              ImageMessageEntity(
                id: doc.id,
                image: url,
                aspectRatio: params.aspectRatio,
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

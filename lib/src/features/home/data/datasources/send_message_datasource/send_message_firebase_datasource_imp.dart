import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/enums/message_type.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/params/send_message_params.dart';

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
              'seen': false,
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
                seen: false,
              ),
            );
          }
        case MessageType.image:
          {
            final name = '$uid-${DateTime.now().toUtc().toIso8601String()}';

            final upload = await storage.ref().child(uid).child(name).putString(
                  params.image,
                  format: PutStringFormat.dataUrl,
                );

            final url = await upload.ref.getDownloadURL();

            final message = <String, dynamic>{
              'from': uid,
              'to': params.to,
              'image': url,
              'aspect_ratio': params.aspectRatio,
              'type': params.type.desc,
              'time': time,
              'seen': false,
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
                seen: false,
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
                seen: false,
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
                seen: false,
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
                seen: false,
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

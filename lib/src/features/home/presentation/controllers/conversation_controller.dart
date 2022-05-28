import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talking/src/core/data/dtos/user_dto.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/params/send_message_params.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/domain/usecases/send_message_usecase/send_message_usecase.dart';

class ConversationController {
  final ISendMessageUsecase _sendMessageUsecase;

  ConversationController(this._sendMessageUsecase);

  Future<void> sendTextMessage(String message, String friendUid) async {
    final result = await _sendMessageUsecase(SendMessageParams.text(message, friendUid));

    if (result.isRight()) {
      result.fold((l) => null, (r) => r) as TextMessageEntity;
    } else {
      final exception = result.fold((l) => l, (r) => null) as AppException;

      log(exception.error, name: 'SendMessageException');
    }
  }

  Future<void> sendImageMessage(String friendUid) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final image = decodeImage(await pickedFile.readAsBytes());

    if (image == null) return;

    final aspectRatio = image.width / image.height;

    final result = await _sendMessageUsecase(
      SendMessageParams.image(
        pickedFile.path,
        aspectRatio,
        friendUid,
      ),
    );

    if (result.isRight()) {
      result.fold((l) => null, (r) => r) as ImageMessageEntity;
    } else {
      final exception = result.fold((l) => l, (r) => null) as AppException;

      log(exception.error, name: 'SendMessageException');
    }
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> stream(String userUid, String friendUid) {
    final firestore = FirebaseFirestore.instance;

    final from = firestore
        .collection('cl_messages')
        .where('from', isEqualTo: userUid)
        .where('to', isEqualTo: friendUid)
        .snapshots(includeMetadataChanges: true);

    final to = firestore
        .collection('cl_messages')
        .where('from', isEqualTo: friendUid)
        .where('to', isEqualTo: userUid)
        .snapshots(includeMetadataChanges: true);

    final data = Rx.combineLatest2<QuerySnapshot<Map<String, dynamic>>, QuerySnapshot<Map<String, dynamic>>,
        List<QueryDocumentSnapshot<Map<String, dynamic>>>>(from, to, (a, b) => [...a.docs, ...b.docs]);

    return data.asBroadcastStream();
  }

  // Stream<UserEntity?> friendStream(String uid) {
  //   final firestore = FirebaseFirestore.instance;

  //   final stream = firestore.collection('cl_users').doc(uid).snapshots();

  //   return stream.switchMap((value) => UserDto.fromFirestore(value)).asBroadcastStream();
  // }
}

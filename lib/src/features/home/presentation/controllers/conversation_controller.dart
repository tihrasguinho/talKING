import 'dart:convert';
import 'dart:developer';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';
import 'package:rxdart/rxdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talking/src/core/data/dtos/app_dtos.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/params/send_message_params.dart';

class ConversationController {
  final ISendMessageUsecase _sendMessageUsecase;
  final IMarkAsSeenUsecase _markAsSeenUsecase;
  final IDeleteMessageUsecase _deleteMessageUsecase;
  final IUpdateTypingToUsecase _updateTypingToUsecase;

  ConversationController(
    this._sendMessageUsecase,
    this._markAsSeenUsecase,
    this._deleteMessageUsecase,
    this._updateTypingToUsecase,
  );

  final picker = ImagePicker();

  Future<void> updateTypingTo(String friendUid) async {
    final result = await _updateTypingToUsecase(friendUid);

    if (result.isLeft()) {
      final exception = result.fold((l) => l, (r) => null) as AppException;

      log(exception.error, name: 'UpdateTypingToException');
    }
  }

  Future<void> deleteMessages(List<MessageEntity> messages) async {
    for (var message in messages) {
      final result = await _deleteMessageUsecase(message);

      if (result.isLeft()) {
        final exception = result.fold((l) => l, (r) => null) as AppException;

        log(exception.error, name: 'DeleteMessageException');
      }
    }
  }

  Future<void> markAsSeen(List<MessageEntity> messages) async {
    for (var message in messages) {
      if (!message.isMe && !message.seen) {
        final result = await _markAsSeenUsecase(message.id);

        if (result.isLeft()) {
          final exception = result.fold((l) => l, (r) => null) as AppException;

          log(exception.error, name: 'MarkAsSeenException');
        }
      }
    }
  }

  Future<SendMessageParams?> pickImage(ImageSource source, String friendUid) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) return null;

    final filename = pickedFile.name;

    final sufix = filename.split('.').last.toLowerCase();

    final allowed = ['jpg', 'jpeg', 'png', 'gif'];

    if (!allowed.contains(sufix)) return null;

    final compressed = await FlutterImageCompress.compressWithFile(
      pickedFile.path,
      quality: 75,
      minWidth: 512,
      minHeight: 512,
    );

    if (compressed == null) return null;

    final base64 = base64Encode(compressed);

    final image = decodeImage(compressed);

    return SendMessageParams.image(
      'data:image/$sufix;base64,$base64',
      image!.width / image.height,
      friendUid,
    );
  }

  Future<void> sendMessage(SendMessageParams params) async {
    final result = await _sendMessageUsecase(params);

    if (result.isLeft()) {
      final exception = result.fold((l) => l, (r) => null) as AppException;

      log(exception.error, name: 'SendMessageException');
    }
  }

  Future<void> sendTextMessage(String message, String friendUid) async {
    final result = await _sendMessageUsecase(SendMessageParams.text(message, friendUid));

    if (result.isLeft()) {
      final exception = result.fold((l) => l, (r) => null) as AppException;

      log(exception.error, name: 'SendMessageException');
    }
  }

  Future<void> sendImageMessage(String friendUid) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final filename = pickedFile.name;

    final sufix = filename.split('.').last.toLowerCase();

    final allowed = ['jpg', 'jpeg', 'png', 'gif'];

    if (!allowed.contains(sufix)) return;

    final compressed = await FlutterImageCompress.compressWithFile(
      pickedFile.path,
      quality: 75,
      minWidth: 512,
      minHeight: 512,
    );

    if (compressed == null) return;

    final base64 = base64Encode(compressed);

    final image = decodeImage(compressed);

    final result = await _sendMessageUsecase(
      SendMessageParams.image(
        'data:image/$sufix;base64,$base64',
        image!.width / image.height,
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

  Stream<UserEntity> friendStream(String uid) {
    final firestore = FirebaseFirestore.instance;

    final stream = firestore.collection('cl_users').doc(uid).snapshots();

    return stream.asyncMap((doc) => UserDto.fromFirestore(doc));
  }
}

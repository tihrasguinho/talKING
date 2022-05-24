import 'dart:developer';

import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
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
}

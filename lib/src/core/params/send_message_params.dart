import 'package:talking/src/core/enums/message_type.dart';

class SendMessageParams {
  final String message;
  final String image;
  final String audio;
  final String video;
  final String to;
  final MessageType type;

  SendMessageParams({
    required this.message,
    required this.image,
    required this.audio,
    required this.video,
    required this.to,
    required this.type,
  });

  factory SendMessageParams.text(String message, String friendUid) {
    return SendMessageParams(
      message: message,
      to: friendUid,
      image: '',
      audio: '',
      video: '',
      type: MessageType.text,
    );
  }

  factory SendMessageParams.image(String imagePath, String friendUid) {
    return SendMessageParams(
      message: '',
      to: friendUid,
      image: imagePath,
      audio: '',
      video: '',
      type: MessageType.image,
    );
  }

  factory SendMessageParams.audio(String audioPath, String friendUid) {
    return SendMessageParams(
      message: '',
      to: friendUid,
      image: '',
      audio: audioPath,
      video: '',
      type: MessageType.audio,
    );
  }

  factory SendMessageParams.video(String videoPath, String friendUid) {
    return SendMessageParams(
      message: '',
      to: friendUid,
      image: '',
      audio: '',
      video: videoPath,
      type: MessageType.video,
    );
  }
}

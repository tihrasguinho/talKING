import 'package:talking/src/core/enums/message_type.dart';

class SendMessageParams {
  final String message;
  final String image;
  final double aspectRatio;
  final String audio;
  final String video;
  final String to;
  final MessageType type;

  SendMessageParams({
    required this.message,
    required this.image,
    required this.aspectRatio,
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
      aspectRatio: 0.0,
      audio: '',
      video: '',
      type: MessageType.text,
    );
  }

  factory SendMessageParams.image(String imagePath, double aspectRatio, String friendUid) {
    return SendMessageParams(
      message: '',
      to: friendUid,
      image: imagePath,
      aspectRatio: aspectRatio,
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
      aspectRatio: 0.0,
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
      aspectRatio: 0.0,
      audio: '',
      video: videoPath,
      type: MessageType.video,
    );
  }
}

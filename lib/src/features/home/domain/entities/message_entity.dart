import 'package:talking/src/core/enums/message_type.dart';

abstract class MessageEntity {
  final String id;
  final String from;
  final String to;
  final MessageType type;
  final DateTime time;

  MessageEntity({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    required this.time,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageEntity && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^ from.hashCode ^ to.hashCode ^ type.hashCode ^ time.hashCode;
  }
}

class TextMessageEntity extends MessageEntity {
  final String message;

  TextMessageEntity({
    required super.id,
    required this.message,
    required super.from,
    required super.to,
    required super.type,
    required super.time,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TextMessageEntity && other.id == super.id;
  }

  @override
  int get hashCode => message.hashCode;
}

class ImageMessageEntity extends MessageEntity {
  final String image;
  final double aspectRatio;

  ImageMessageEntity({
    required super.id,
    required this.image,
    required this.aspectRatio,
    required super.from,
    required super.to,
    required super.type,
    required super.time,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageMessageEntity && other.id == id;
  }

  @override
  int get hashCode => image.hashCode;
}

// class MessageEntity {
//   final String id;
//   final String message;
//   final String from;
//   final String to;
//   final MessageType type;
//   final DateTime time;

//   MessageEntity({
//     required this.id,
//     required this.message,
//     required this.from,
//     required this.to,
//     required this.type,
//     required this.time,
//   });
// }
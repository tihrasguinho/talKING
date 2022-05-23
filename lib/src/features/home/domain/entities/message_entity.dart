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

    return other is MessageEntity &&
        other.id == id &&
        other.from == from &&
        other.to == to &&
        other.type == type &&
        other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^ from.hashCode ^ to.hashCode ^ type.hashCode ^ time.hashCode;
  }

  @override
  String toString() {
    return 'MessageEntity(id: $id, from: $from, to: $to, type: $type, time: $time)';
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

    return other is TextMessageEntity &&
        other.id == id &&
        other.message == message &&
        other.from == from &&
        other.to == to &&
        other.type == type &&
        other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^ message.hashCode ^ from.hashCode ^ to.hashCode ^ type.hashCode ^ time.hashCode;
  }

  @override
  String toString() {
    return 'MessageEntity(id: $id, message: $message, from: $from, to: $to, type: $type, time: $time)';
  }

  TextMessageEntity copyWith({
    String? id,
    String? message,
    String? from,
    String? to,
    MessageType? type,
    DateTime? time,
  }) {
    return TextMessageEntity(
      id: id ?? super.id,
      message: message ?? this.message,
      from: from ?? super.from,
      to: to ?? super.to,
      type: type ?? super.type,
      time: time ?? super.time,
    );
  }
}

class ImageMessageEntity extends MessageEntity {
  final String imageUrl;

  ImageMessageEntity({
    required super.id,
    required this.imageUrl,
    required super.from,
    required super.to,
    required super.type,
    required super.time,
  });
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

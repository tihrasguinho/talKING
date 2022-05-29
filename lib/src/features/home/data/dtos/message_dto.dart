import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:talking/src/core/enums/message_type.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';

extension MessageDto on MessageEntity {
  // REFACTOR

  static MessageEntity fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    final type_ = MessageType.values.singleWhere((e) => e.desc == data['type']);

    switch (type_) {
      case MessageType.text:
        {
          final timestamp = data['time'] as Timestamp;

          return TextMessageEntity(
            id: doc.id,
            message: data['message'] ?? '',
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
      case MessageType.image:
        {
          final timestamp = data['time'] as Timestamp;

          return ImageMessageEntity(
            id: doc.id,
            image: data['image'] ?? '',
            aspectRatio: data['aspect_ratio'] ?? 1 / 1,
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
      case MessageType.audio:
        {
          final timestamp = data['time'] as Timestamp;

          return TextMessageEntity(
            id: doc.id,
            message: data['message'] ?? '',
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
      case MessageType.video:
        {
          final timestamp = data['time'] as Timestamp;

          return TextMessageEntity(
            id: doc.id,
            message: data['message'] ?? '',
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
    }
  }

  static MessageEntity fromMap(Map<String, dynamic> data) {
    final type_ = MessageType.values.singleWhere((e) => e.desc == data['type']);

    switch (type_) {
      case MessageType.text:
        {
          final timestamp = data['time'] as Timestamp;

          return TextMessageEntity(
            id: data['id'] ?? '',
            message: data['message'] ?? '',
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
      case MessageType.image:
        {
          final timestamp = data['time'] as Timestamp;

          return ImageMessageEntity(
            id: data['id'] ?? '',
            image: data['image'] ?? '',
            aspectRatio: data['aspect_ratio'] ?? 1 / 1,
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
      case MessageType.audio:
        {
          final timestamp = data['time'] as Timestamp;

          return TextMessageEntity(
            id: data['id'] ?? '',
            message: data['message'] ?? '',
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
      case MessageType.video:
        {
          final timestamp = data['time'] as Timestamp;

          return TextMessageEntity(
            id: data['id'] ?? '',
            message: data['message'] ?? '',
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
    }
  }

  static MessageEntity fromJson(String source) {
    final data = jsonDecode(source);

    final type_ = MessageType.values.singleWhere((e) => e.desc == data['type']);

    switch (type_) {
      case MessageType.text:
        {
          final timestamp = data['time'] as Timestamp;

          return TextMessageEntity(
            id: data['id'] ?? '',
            message: data['message'] ?? '',
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
      case MessageType.image:
        {
          final timestamp = data['time'] as Timestamp;

          return ImageMessageEntity(
            id: data['id'] ?? '',
            image: data['image'] ?? '',
            aspectRatio: data['aspect_ratio'] ?? 1 / 1,
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
      case MessageType.audio:
        {
          final timestamp = data['time'] as Timestamp;

          return TextMessageEntity(
            id: data['id'] ?? '',
            message: data['message'] ?? '',
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
      case MessageType.video:
        {
          final timestamp = data['time'] as Timestamp;

          return TextMessageEntity(
            id: data['id'] ?? '',
            message: data['message'] ?? '',
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            type: type_,
            time: DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch),
            seen: data['seen'] ?? false,
          );
        }
    }
  }

  Map<String, dynamic> toMap() {
    switch (type) {
      case MessageType.text:
        {
          final item = this as TextMessageEntity;

          return {
            'id': item.id,
            'message': item.message,
            'from': item.from,
            'to': item.to,
            'type': item.type.desc,
            'time': item.time.millisecondsSinceEpoch,
            'seen': item.seen,
          };
        }
      case MessageType.image:
        {
          final item = this as ImageMessageEntity;

          return {
            'id': item.id,
            'image': item.image,
            'aspect_ratio': item.aspectRatio,
            'from': item.from,
            'to': item.to,
            'type': item.type.desc,
            'time': item.time.millisecondsSinceEpoch,
            'seen': item.seen,
          };
        }
      case MessageType.audio:
        {
          return {};
        }
      case MessageType.video:
        {
          return {};
        }
    }
  }

  String toJson() => jsonEncode(toMap());

  // END REFACTOR

  String get timeFormatted {
    final formatter = DateFormat('HH:mm');

    return formatter.format(time);
  }

  bool get isMe => Hive.box('app').get('uid') == from;
}

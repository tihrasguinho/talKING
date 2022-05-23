import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:talking/src/core/enums/message_type.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';

extension MessageDto on MessageEntity {
  static TextMessageEntity textFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final time = data['time'] as Timestamp;

    return TextMessageEntity(
      id: doc.id,
      message: data['message'] ?? '',
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      type: MessageType.values.singleWhere((e) => e.desc == data['type']),
      time: DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch),
    );
  }

  static TextMessageEntity textFromJson(String source) {
    final data = jsonDecode(source);

    return TextMessageEntity(
      id: data['id'] ?? '',
      message: data['message'] ?? '',
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      type: MessageType.text,
      time: DateTime.parse(data['time']),
    );
  }

  Map<String, dynamic> textToMap() {
    final item = this as TextMessageEntity;

    return {
      'id': item.id,
      'message': item.message,
      'from': item.from,
      'to': item.to,
      'type': item.type.desc,
      'time': item.time.toIso8601String(),
    };
  }

  String textToJson() => jsonEncode(textToMap());

  String get timeFormatted {
    final formatter = DateFormat('HH:mm');

    return formatter.format(time);
  }
}

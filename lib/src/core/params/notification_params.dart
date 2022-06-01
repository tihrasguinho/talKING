import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:talking/src/core/enums/notification_type.dart';

class NotificationParams {
  final Map<String, dynamic> notification;
  final Map<String, dynamic> message;
  final NotificationType type;

  NotificationParams({
    required this.notification,
    required this.message,
    required this.type,
  });

  NotificationParams copyWith({
    Map<String, dynamic>? notification,
    Map<String, dynamic>? message,
    NotificationType? type,
  }) {
    return NotificationParams(
      notification: notification ?? this.notification,
      message: message ?? this.message,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notification': notification,
      'message': message,
      'type': type.value,
    };
  }

  factory NotificationParams.fromMap(Map<String, dynamic> map) {
    final $notification = jsonDecode(map['notification']);
    final $message = jsonDecode(map['message']);

    return NotificationParams(
      notification: Map<String, dynamic>.from($notification),
      message: Map<String, dynamic>.from($message),
      type: NotificationType.values.singleWhere((x) => x.value == map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationParams.fromJson(String source) => NotificationParams.fromMap(json.decode(source));

  @override
  String toString() => 'NotificationParams(notification: $notification, message: $message, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationParams &&
        mapEquals(other.notification, notification) &&
        mapEquals(other.message, message) &&
        other.type == type;
  }

  @override
  int get hashCode => notification.hashCode ^ message.hashCode ^ type.hashCode;
}

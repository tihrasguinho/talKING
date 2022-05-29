import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';

extension UserDto on UserEntity {
  static UserEntity fromMap(Map data) {
    final timestamp = data['created_at'] as Timestamp;
    final lastConnection = data['last_connection'] as Timestamp;

    return UserEntity(
      uid: data['uid'],
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      createdAt: timestamp.millisecondsSinceEpoch,
      online: data['online'] ?? false,
      lastConnection: lastConnection.millisecondsSinceEpoch,
      typingTo: data['typing_to'] ?? '',
    );
  }

  static UserEntity fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final timestamp = data['created_at'] as Timestamp;
    final lastConnection = data['last_connection'] as Timestamp;

    return UserEntity(
      uid: doc.id,
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      createdAt: timestamp.millisecondsSinceEpoch,
      online: data['online'] ?? false,
      lastConnection: lastConnection.millisecondsSinceEpoch,
      typingTo: data['typing_to'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'username': username,
        'email': email,
        'image': image,
        'created_at': createdAt,
        'online': online,
        'last_connection': lastConnection,
        'typing_to': typingTo,
      };

  String toJson() => jsonEncode(toMap());

  String get lastConnectionFormatted {
    final date = DateTime.fromMillisecondsSinceEpoch(lastConnection).toLocal();

    final now = DateTime.now();

    final hours = DateFormat('HH:mm', 'en_US');

    final day = DateFormat('dd', 'en_US');

    final month = DateFormat('MMM', 'en_US');

    final year = DateFormat('yyyy', 'en_US');

    final difference = now.difference(date);

    final sameYear = date.year == now.year;

    final sameDay = date.day == now.day;

    if (difference.inHours < 1) {
      return 'Recent online';
    } else if (difference.inHours >= 1 && difference.inHours < 24 && sameDay) {
      return 'Last time online at ${hours.format(date)}';
    } else if (difference.inHours >= 1 && difference.inHours < 24 && !sameDay) {
      return 'Last time online yesterday at ${hours.format(date)}';
    } else if (difference.inDays >= 1 && difference.inDays < 2) {
      return 'Last time online yesterday';
    } else if (difference.inDays >= 2 && difference.inDays <= 365) {
      return 'Last time online ${month.format(date)} ${day.format(date)} at ${hours.format(date)}';
    } else if (difference.inDays >= 2 && difference.inDays <= 365 && !sameYear) {
      return 'Last time online ${month.format(date)} ${day.format(date)}, ${year.format(date)} at ${hours.format(date)}';
    } else if (difference.inDays > 365) {
      return 'Last time online ${month.format(date)} ${day.format(date)}, ${year.format(date)} at ${hours.format(date)}';
    } else {
      return 'Last time online ${month.format(date)} ${day.format(date)}, ${year.format(date)} at ${hours.format(date)}';
    }
  }
}

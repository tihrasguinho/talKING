import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';

extension UserDto on UserEntity {
  static UserEntity fromMap(Map data) {
    final timestamp = data['created_at'] as Timestamp;

    return UserEntity(
      uid: data['uid'],
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      createdAt: timestamp.millisecondsSinceEpoch,
    );
  }

  static UserEntity fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final timestamp = data['created_at'] as Timestamp;

    return UserEntity(
      uid: doc.id,
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      createdAt: timestamp.millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'username': username,
        'email': email,
        'image': image,
        'created_at': createdAt,
      };

  String toJson() => jsonEncode(toMap());
}

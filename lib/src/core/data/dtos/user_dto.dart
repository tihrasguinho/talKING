import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';

extension UserDto on UserEntity {
  static UserEntity fromMap(Map data) {
    final creadtedAt = data['created_at'] as Timestamp;

    return UserEntity(
      uid: data['uid'],
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(creadtedAt.millisecondsSinceEpoch),
    );
  }

  static UserEntity fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final creadtedAt = data['created_at'] as Timestamp;

    return UserEntity(
      uid: doc.id,
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(creadtedAt.millisecondsSinceEpoch),
    );
  }
}

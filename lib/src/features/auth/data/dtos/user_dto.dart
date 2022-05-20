import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talking/src/features/auth/domain/entities/user_entity.dart';

extension UserDto on UserEntity {
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

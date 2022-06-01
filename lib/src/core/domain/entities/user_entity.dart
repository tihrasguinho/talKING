import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class UserEntity extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final int createdAt;

  @HiveField(6)
  final bool online;

  @HiveField(7)
  final int lastConnection;

  @HiveField(8)
  final String typingTo;

  UserEntity({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.image,
    required this.createdAt,
    required this.online,
    required this.lastConnection,
    required this.typingTo,
  });

  UserEntity copyWith({
    String? uid,
    String? name,
    String? username,
    String? email,
    String? image,
    int? createdAt,
    bool? online,
    int? lastConnection,
    String? typingTo,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      online: online ?? this.online,
      lastConnection: lastConnection ?? this.lastConnection,
      typingTo: typingTo ?? this.typingTo,
    );
  }

  @override
  String toString() {
    return 'UserEntity(uid: $uid, name: $name, username: $username, email: $email, image: $image, createdAt: $createdAt, online: $online, lastConnection: $lastConnection, typingTo: $typingTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEntity &&
        other.uid == uid &&
        other.name == name &&
        other.username == username &&
        other.email == email &&
        other.image == image &&
        other.createdAt == createdAt &&
        other.typingTo == typingTo;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        image.hashCode ^
        createdAt.hashCode ^
        typingTo.hashCode;
  }
}

class UserEntityAdapter extends TypeAdapter<UserEntity> {
  @override
  final typeId = 0;

  @override
  UserEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return UserEntity(
      uid: fields[0] as String,
      name: fields[1] as String,
      username: fields[2] as String,
      email: fields[3] as String,
      image: fields[4] as String,
      createdAt: fields[5] as int,
      online: fields[6] as bool,
      lastConnection: fields[7] as int,
      typingTo: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.online)
      ..writeByte(7)
      ..write(obj.lastConnection)
      ..writeByte(8)
      ..write(obj.typingTo);
  }
}

class UserEntity {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String image;
  final DateTime createdAt;

  UserEntity({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.image,
    required this.createdAt,
  });

  UserEntity copyWith({
    String? uid,
    String? name,
    String? username,
    String? email,
    String? image,
    DateTime? createdAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserEntity(uid: $uid, name: $name, username: $username, email: $email, image: $image, createdAt: $createdAt)';
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
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ name.hashCode ^ username.hashCode ^ email.hashCode ^ image.hashCode ^ createdAt.hashCode;
  }
}

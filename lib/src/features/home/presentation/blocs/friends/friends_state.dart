import 'package:talking/src/core/domain/entities/user_entity.dart';

abstract class FriendsState {
  final List<UserEntity> friends;

  FriendsState(this.friends);
}

class SuccessFriendsState extends FriendsState {
  SuccessFriendsState(super.friends);
}

class ErrorFriendsState extends FriendsState {
  final String error;

  ErrorFriendsState(this.error) : super([]);
}

class LoadingFriendsState extends FriendsState {
  LoadingFriendsState() : super([]);
}

class InitialFriendsState extends FriendsState {
  InitialFriendsState() : super([]);
}

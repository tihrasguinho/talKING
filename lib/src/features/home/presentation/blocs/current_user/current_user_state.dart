import 'package:talking/src/core/domain/entities/user_entity.dart';

abstract class CurrentUserState {}

class SuccessCurrentUserState extends CurrentUserState {
  final UserEntity user;

  SuccessCurrentUserState(this.user);
}

class ErrorCurrentUserState extends CurrentUserState {
  final String error;

  ErrorCurrentUserState(this.error);
}

class LoadingCurrentUserState extends CurrentUserState {}

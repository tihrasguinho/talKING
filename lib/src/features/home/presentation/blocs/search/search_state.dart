import 'package:talking/src/core/domain/entities/user_entity.dart';

abstract class SearchState {
  final List<UserEntity> users;

  SearchState(this.users);
}

class SuccessSearchState extends SearchState {
  SuccessSearchState(super.users);
}

class ErrorSearchState extends SearchState {
  final String error;

  ErrorSearchState(this.error) : super([]);
}

class LoadingSearchState extends SearchState {
  LoadingSearchState() : super([]);
}

class InitialSearchState extends SearchState {
  InitialSearchState() : super([]);
}

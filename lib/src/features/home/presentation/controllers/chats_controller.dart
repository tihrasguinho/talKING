import 'package:talking/src/features/home/presentation/blocs/current_user/current_user_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_bloc.dart';

class ChatsController {
  final FriendsBloc _friendsBloc;
  final CurrentUserBloc _currentUserBloc;

  ChatsController(this._friendsBloc, this._currentUserBloc);
}

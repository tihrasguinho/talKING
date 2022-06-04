import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_state.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key, required this.friendUid}) : super(key: key);

  final String friendUid;

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final FriendsBloc bloc = Modular.get();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FriendsState>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final state = snapshot.data;

        if (state == null) return const SizedBox();

        if (state is LoadingFriendsState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorFriendsState) {
          return Center(child: Text(state.error));
        } else if (state is SuccessFriendsState) {
          final friend = state.friends.firstWhere((e) => e.uid == widget.friendUid);

          return Scaffold(
            appBar: AppBar(
              title: Text(friend.name),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

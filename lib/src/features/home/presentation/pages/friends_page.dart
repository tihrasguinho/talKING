import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/widgets/custom_circle_avatar.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_event.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FriendsBloc bloc = Modular.get();

  @override
  void initState() {
    super.initState();

    bloc.emit(FetchFriendsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<UserEntity>>(
        valueListenable: bloc,
        builder: (context, state, child) {
          return ListView.builder(
            itemCount: state.length,
            itemBuilder: (context, index) {
              final user = state[index];

              return ListTile(
                title: Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white,
                      ),
                ),
                subtitle: Text(
                  '@${user.username}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white70,
                      ),
                ),
                leading: CustomCircleAvatar(user: user),
                trailing: IconButton(
                  onPressed: () => {
                    Modular.to.pop(),
                    Modular.to.pushNamed('/conversation', arguments: user),
                  },
                  icon: Transform.rotate(
                    angle: -0.5,
                    child: const Icon(Icons.send_rounded),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

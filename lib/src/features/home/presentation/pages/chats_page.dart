import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/enums/message_type.dart';
import 'package:talking/src/core/widgets/custom_circle_avatar.dart';
import 'package:talking/src/features/home/data/dtos/message_dto.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/presentation/blocs/chats/chats_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/chats/chats_state.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_state.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final ChatsBloc chatsBloc = Modular.get();
  final FriendsBloc friendsBloc = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder<FriendsState>(
        stream: friendsBloc.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();

          final friendsState = snapshot.data;

          if (friendsState is LoadingFriendsState) {
            return const Center(child: CircularProgressIndicator());
          } else if (friendsState is ErrorFriendsState) {
            return Center(child: Text(friendsState.error));
          } else if (friendsState is SuccessFriendsState) {
            // Second StreamBuilder

            return StreamBuilder<ChatsState>(
              stream: chatsBloc.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                final chatsState = snapshot.data;

                if (chatsState is LoadingChatsState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (chatsState is SuccessChatsState) {
                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 8.0),
                    separatorBuilder: (_, __) {
                      return Container(
                        color: const Color(0xFF212121),
                        height: 1,
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(left: 75.0),
                      );
                    },
                    itemCount: chatsState.chats.length,
                    itemBuilder: (context, index) {
                      final chat = chatsState.chats[index];
                      final friend = friendsState.friends.firstWhere((e) => e.uid == chat.friend);

                      return ListTile(
                        onTap: () => Modular.to.pushNamed('/conversation', arguments: friend),
                        leading: CustomCircleAvatar(
                          user: friend,
                        ),
                        title: Text(
                          friend.name,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        subtitle: _messageMap(chat.messages.first),
                        trailing: Text(
                          chat.messages.first.timeFormatted,
                          style: Theme.of(context).textTheme.overline!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _messageMap(MessageEntity message) {
    switch (message.type) {
      case MessageType.text:
        {
          message as TextMessageEntity;

          return Text(
            message.message,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.normal,
                ),
          );
        }
      case MessageType.image:
        {
          return Row(
            children: [
              const Icon(
                Icons.image_rounded,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 4.0),
              Text(
                'Image',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          );
        }
      case MessageType.audio:
        {
          return Row(
            children: [
              const Icon(
                Icons.mic_rounded,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 4.0),
              Text(
                'Audio',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          );
        }
      case MessageType.video:
        {
          return Row(
            children: [
              const Icon(
                Icons.video_camera_back_rounded,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 4.0),
              Text(
                'Video',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          );
        }
    }
  }
}

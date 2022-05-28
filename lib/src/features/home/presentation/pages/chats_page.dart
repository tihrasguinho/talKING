import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/data/dtos/app_dtos.dart';
import 'package:talking/src/core/enums/message_type.dart';
import 'package:talking/src/core/widgets/custom_circle_avatar.dart';
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
                        leading: Stack(
                          children: [
                            CustomCircleAvatar(
                              user: friend,
                            ),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: friend.online
                                  ? Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                        title: Text(
                          friend.name,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        subtitle: _messageMap(chat.message),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              chat.time,
                              style: Theme.of(context).textTheme.overline!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            Container(
                              width: 18,
                              height: 18,
                              decoration: chat.unread == 0
                                  ? null
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              child: chat.unread == 0
                                  ? null
                                  : Center(
                                      child: Text(
                                        chat.unread.toString(),
                                        style: Theme.of(context).textTheme.overline!.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            const Shadow(
                                              color: Colors.black26,
                                              blurRadius: 2,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ],
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

          return Row(
            children: [
              message.isMe
                  ? Icon(
                      message.seen ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                      color: message.seen ? Colors.white70 : Colors.white70,
                      size: 16,
                    )
                  : const SizedBox(),
              message.isMe ? const SizedBox(width: 4.0) : const SizedBox(),
              Text(
                message.message,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          );
        }
      case MessageType.image:
        {
          return Row(
            children: [
              message.isMe
                  ? Icon(
                      message.seen ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                      color: message.seen ? Colors.white70 : Colors.white70,
                      size: 16,
                    )
                  : const SizedBox(),
              message.isMe ? const SizedBox(width: 4.0) : const SizedBox(),
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
              message.isMe
                  ? Icon(
                      message.seen ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                      color: message.seen ? Theme.of(context).colorScheme.secondary : Colors.white70,
                      size: 16,
                    )
                  : const SizedBox(),
              message.isMe ? const SizedBox(width: 4.0) : const SizedBox(),
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
              message.isMe
                  ? Icon(
                      message.seen ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                      color: message.seen ? Theme.of(context).colorScheme.secondary : Colors.white70,
                      size: 16,
                    )
                  : const SizedBox(),
              message.isMe ? const SizedBox(width: 4.0) : const SizedBox(),
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

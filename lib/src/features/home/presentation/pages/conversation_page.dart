import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/enums/message_type.dart';
import 'package:talking/src/core/widgets/custom_circle_avatar.dart';
import 'package:talking/src/features/home/data/dtos/message_dto.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_event.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_state.dart';
import 'package:talking/src/features/home/presentation/controllers/conversation_controller.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key, required this.friend}) : super(key: key);

  final UserEntity friend;

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final ConversationController controller = Modular.get();
  final MessagesBloc bloc = Modular.get();

  final firestore = FirebaseFirestore.instance;

  final input = TextEditingController();

  final hive = Hive.box('app');

  late StreamSubscription<List<QueryDocumentSnapshot<Map<String, dynamic>>>> subscription;

  @override
  void initState() {
    super.initState();

    subscription = controller.stream(hive.get('uid'), widget.friend.uid).listen((event) {
      log(event.length.toString());

      bloc.input.add(LoadMessagesEvent(event));
    });
  }

  @override
  void dispose() {
    input.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Row(
          children: [
            CustomCircleAvatar(
              user: widget.friend,
              size: const Size(32, 32),
            ),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.friend.name),
                // Text(
                //   'Online',
                //   style: Theme.of(context).textTheme.overline!.copyWith(
                //         color: Colors.white70,
                //       ),
                // ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<MessagesState>(
              stream: bloc.output,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                final state = snapshot.data;

                if (state is LoadingMessagesState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ErrorMessagesState) {
                  return Center(child: Text(state.error));
                } else if (state is SuccessMessagesState) {
                  return ListView.builder(
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 4.0),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isMe = message.from == hive.get('uid');

                      switch (message.type) {
                        case MessageType.text:
                          {
                            message as TextMessageEntity;

                            return Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 4.0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Theme.of(context).colorScheme.secondaryContainer
                                      : Theme.of(context).appBarTheme.backgroundColor,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      message.message,
                                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    Text(
                                      message.timeFormatted,
                                      style: Theme.of(context).textTheme.overline!.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        case MessageType.image:
                          {
                            message as ImageMessageEntity;

                            return Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: isMe ? 24.0 : 75.0,
                                  left: isMe ? 75.0 : 24.0,
                                  top: 4.0,
                                  bottom: 4.0,
                                ),
                                child: AspectRatio(
                                  aspectRatio: message.aspectRatio,
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: isMe
                                          ? Theme.of(context).colorScheme.secondaryContainer
                                          : Theme.of(context).appBarTheme.backgroundColor,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          message.image,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return const Center(child: CircularProgressIndicator());
                                          },
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 8.0,
                                            ),
                                            child: Text(
                                              message.timeFormatted,
                                              style: Theme.of(context).textTheme.overline!.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        case MessageType.audio:
                          {
                            message as TextMessageEntity;

                            return Text(message.message);
                          }
                        case MessageType.video:
                          {
                            message as TextMessageEntity;

                            return Text(message.message);
                          }
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: input,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white,
                          ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        filled: false,
                        border: InputBorder.none,
                        hintText: 'Send your message',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.sendImageMessage(widget.friend.uid),
                    icon: const Icon(Icons.attach_file_rounded),
                  ),
                  IconButton(
                    onPressed: () => {
                      controller.sendTextMessage(input.text, widget.friend.uid),
                      input.clear(),
                    },
                    icon: Transform.rotate(
                      angle: -0.5,
                      child: const Icon(Icons.send_rounded),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

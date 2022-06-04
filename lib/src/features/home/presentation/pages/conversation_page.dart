import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talking/src/core/data/dtos/app_dtos.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/enums/message_type.dart';
import 'package:talking/src/core/params/send_message_params.dart';
import 'package:talking/src/core/utils/app_config.dart';
import 'package:talking/src/core/widgets/custom_circle_avatar.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_event.dart';
import 'package:talking/src/features/home/presentation/blocs/messages/messages_state.dart';
import 'package:talking/src/features/home/presentation/controllers/conversation_controller.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key, required this.friendUid}) : super(key: key);

  final String friendUid;

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final ConversationController controller = Modular.get();
  final MessagesBloc bloc = Modular.get();

  final selecteds = <MessageEntity>[];

  final firestore = FirebaseFirestore.instance;

  final input = TextEditingController();

  final hive = Hive.box('app');

  final emojis = ValueNotifier<bool>(false);

  final attach = ValueNotifier<bool>(false);

  late StreamSubscription<List<QueryDocumentSnapshot<Map<String, dynamic>>>> subscription;

  void updateSelecteds(MessageEntity message) {
    if (selecteds.any((x) => x.id == message.id)) {
      selecteds.removeWhere((x) => x.id == message.id);
    } else {
      selecteds.add(message);
    }

    setState(() {});
  }

  void clearSelected() {
    setState(() {
      selecteds.clear();
    });
  }

  @override
  void initState() {
    super.initState();

    bloc.emit(InitialMessagesEvent(widget.friendUid));

    input.addListener(() {
      if (input.text.isNotEmpty) {
        controller.updateTypingTo(widget.friendUid);
      } else {
        controller.updateTypingTo('');
      }
    });

    subscription = controller.stream(hive.get('uid'), widget.friendUid).listen((event) {
      bloc.emit(LoadMessagesEvent(event));
    });
  }

  @override
  void dispose() {
    input.dispose();
    subscription.cancel();
    controller.updateTypingTo('');
    emojis.dispose();
    attach.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);

    return StreamBuilder<UserEntity>(
        stream: controller.friendStream(widget.friendUid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();

          final friend = snapshot.data;

          if (friend == null) return const SizedBox();

          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              title: Row(
                children: [
                  CustomCircleAvatar(
                    user: friend,
                    size: const Size(32, 32),
                    onTap: () => Modular.to.pushNamed(
                      '/friend/${widget.friendUid}',
                      arguments: widget.friendUid,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(friend.name),
                      Text(
                        friend.typingTo.isNotEmpty
                            ? 'Typing...'
                            : friend.online
                                ? 'Online'
                                : friend.lastConnectionFormatted,
                        style: Theme.of(context).textTheme.overline!.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                selecteds.isEmpty
                    ? const SizedBox()
                    : selecteds.every((e) => e.from == hive.get('uid'))
                        ? IconButton(
                            onPressed: () async {
                              await controller.deleteMessages(selecteds).whenComplete(() => clearSelected());
                            },
                            icon: const Icon(Icons.delete_forever_rounded),
                          )
                        : const SizedBox(),
                selecteds.isNotEmpty
                    ? SizedBox(
                        width: kMinInteractiveDimension,
                        height: kMinInteractiveDimension,
                        child: Center(
                          child: Container(
                            height: 22.0,
                            width: 22.0,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              selecteds.length.toString(),
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<MessagesState>(
                    stream: bloc.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();

                      final state = snapshot.data;

                      if (state is LoadingMessagesState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ErrorMessagesState) {
                        return Center(child: Text(state.error));
                      } else if (state is SuccessMessagesState) {
                        controller.markAsSeen(state.messages);

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

                                  return Container(
                                    margin: selecteds.contains(message)
                                        ? const EdgeInsets.symmetric(
                                            vertical: .5,
                                          )
                                        : null,
                                    color: selecteds.contains(message) ? Theme.of(context).primaryColorLight.withOpacity(0.3) : Colors.transparent,
                                    child: Align(
                                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                      child: GestureDetector(
                                        onLongPress: () => updateSelecteds(message),
                                        child: Container(
                                          key: ValueKey(message.id),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 4.0,
                                          ),
                                          padding: const EdgeInsets.only(
                                            left: 24.0,
                                            right: 16.0,
                                            top: 8.0,
                                            bottom: 8.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isMe ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
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
                                              const SizedBox(height: 4.0),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    message.timeFormatted,
                                                    style: Theme.of(context).textTheme.overline!.copyWith(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                  message.isMe ? const SizedBox(width: 4.0) : const SizedBox(),
                                                  message.isMe
                                                      ? Icon(
                                                          message.seen ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                                                          color: message.seen ? Colors.white70 : Colors.white70,
                                                          size: 16,
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              case MessageType.image:
                                {
                                  message as ImageMessageEntity;

                                  return Container(
                                    margin: selecteds.contains(message)
                                        ? const EdgeInsets.symmetric(
                                            vertical: 0.5,
                                          )
                                        : null,
                                    color: selecteds.contains(message) ? Theme.of(context).primaryColorLight.withOpacity(0.3) : Colors.transparent,
                                    child: Align(
                                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: isMe ? 16.0 : config.size.width * 0.25,
                                          left: isMe ? config.size.width * 0.25 : 16.0,
                                          top: 4.0,
                                          bottom: 4.0,
                                        ),
                                        child: AspectRatio(
                                          aspectRatio: message.aspectRatio,
                                          child: GestureDetector(
                                            onLongPress: () => updateSelecteds(message),
                                            onTap: () => Modular.to.pushNamed(
                                              '/image-view',
                                              arguments: {
                                                'image': message.image,
                                              },
                                            ),
                                            child: Hero(
                                              tag: message.image,
                                              child: Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  color: isMe ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
                                                  borderRadius: BorderRadius.circular(16.0),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: message.image,
                                                      maxWidthDiskCache: config.size.width.round(),
                                                      progressIndicatorBuilder: (context, str, progress) {
                                                        return Center(
                                                          child: CircularProgressIndicator(
                                                            value: progress.progress,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 8.0,
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              message.timeFormatted,
                                                              style: Theme.of(context).textTheme.overline!.copyWith(
                                                                    color: Colors.white,
                                                                  ),
                                                            ),
                                                            message.isMe ? const SizedBox(width: 4.0) : const SizedBox(),
                                                            message.isMe
                                                                ? Icon(
                                                                    message.seen ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                                                                    color: message.seen ? Colors.white70 : Colors.white70,
                                                                    size: 16,
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
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
                    bottom: 8.0,
                  ),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 250),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: IconButton(
                                onPressed: () {
                                  attach.value = false;
                                  emojis.value = !emojis.value;
                                },
                                icon: const Icon(Icons.emoji_emotions_rounded),
                              ),
                            );
                          },
                        ),
                        Flexible(
                          child: TextField(
                            controller: input,
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                  color: Colors.white,
                                ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                              filled: false,
                              border: InputBorder.none,
                              hintText: 'Send your message',
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: input,
                          builder: (context, child) {
                            return input.text.isNotEmpty
                                ? const SizedBox()
                                : TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 250),
                                    builder: (context, value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: IconButton(
                                          onPressed: () {
                                            emojis.value = false;
                                            attach.value = !attach.value;
                                          },
                                          icon: const Icon(Icons.attach_file_rounded),
                                        ),
                                      );
                                    },
                                  );
                          },
                        ),
                        AnimatedBuilder(
                          animation: input,
                          builder: (context, child) {
                            return input.text.isEmpty
                                ? TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 250),
                                    builder: (context, value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.mic_rounded),
                                        ),
                                      );
                                    },
                                  )
                                : TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 250),
                                    builder: (context, value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: IconButton(
                                          onPressed: () async {
                                            await controller.sendMessage(
                                              SendMessageParams.text(
                                                input.text,
                                                friend.uid,
                                              ),
                                            );

                                            input.clear();
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
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: emojis,
                    builder: (context, value, child) {
                      return AnimatedContainer(
                        height: value ? 256 : 0,
                        duration: const Duration(milliseconds: 250),
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          bottom: value ? 8.0 : 0.0,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      );
                    },
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: attach,
                  builder: (context, value, child) {
                    return AnimatedContainer(
                      clipBehavior: Clip.antiAlias,
                      height: value ? 75 : 0,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 250),
                      width: double.maxFinite,
                      margin: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: value ? 8.0 : 0.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            clipBehavior: Clip.antiAlias,
                            child: FutureBuilder(
                              future: Future.delayed(const Duration(milliseconds: 250)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox();
                                } else {
                                  return AnimatedOpacity(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeIn,
                                    opacity: value ? 1.0 : 0.0,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                attach.value = !attach.value;

                                                final params = await controller.pickImage(
                                                  ImageSource.camera,
                                                  friend.uid,
                                                );

                                                if (params == null) return;

                                                await controller.sendMessage(params);
                                              },
                                              icon: const Icon(Icons.camera_alt_rounded),
                                            ),
                                            Text(
                                              'Camera',
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                attach.value = !attach.value;

                                                final params = await controller.pickImage(
                                                  ImageSource.gallery,
                                                  friend.uid,
                                                );

                                                if (params == null) return;

                                                await controller.sendMessage(params);
                                              },
                                              icon: const Icon(Icons.image_rounded),
                                            ),
                                            Text(
                                              'Galery',
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                attach.value = !attach.value;
                                              },
                                              icon: const Icon(Icons.audio_file_rounded),
                                            ),
                                            Text(
                                              'Audio',
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                attach.value = !attach.value;
                                              },
                                              icon: const Icon(Icons.video_file_rounded),
                                            ),
                                            Text(
                                              'Video',
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}

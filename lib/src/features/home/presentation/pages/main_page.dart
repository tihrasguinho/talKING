import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/features/home/domain/entities/chat_entity.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/presentation/blocs/chats/chats_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/chats/chats_event.dart';
import 'package:talking/src/features/home/presentation/controllers/main_controller.dart';
import 'package:talking/src/features/home/presentation/pages/friends_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainController controller = Modular.get();
  final ChatsBloc chatsBloc = Modular.get();

  int selected = 0;

  void setSelected(int index) {
    setState(() {
      selected = index;
    });

    switch (index) {
      case 0:
        {
          return Modular.to.navigate('/chats');
        }
      case 1:
        {
          return Modular.to.navigate('/profile');
        }
    }
  }

  final allMessages = <ChatEntity>[];

  late StreamSubscription<List<MessageEntity>> subscription;

  @override
  void initState() {
    super.initState();

    subscription = controller.stream().listen((messages) {
      chatsBloc.emit(LoadChatsEvent(messages));
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const RouterOutlet(),
      floatingActionButton: selected == 0
          ? FloatingActionButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) {
                  return const FriendsPage();
                },
              ),
              child: const Icon(Icons.add_rounded),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        height: kToolbarHeight,
        selectedIndex: selected,
        onDestinationSelected: setSelected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

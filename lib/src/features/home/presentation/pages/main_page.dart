import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/features/home/presentation/blocs/chats/chats_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/chats/chats_event.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_event.dart';
import 'package:talking/src/features/home/presentation/controllers/main_controller.dart';
import 'package:talking/src/features/home/presentation/pages/friends_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  final MainController controller = Modular.get();
  final FriendsBloc friendsBloc = Modular.get();
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

  late StreamSubscription<List<MessageEntity>> subscription;

  late StreamSubscription<List<QueryDocumentSnapshot>> groups;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    Modular.to.addListener(() {
      log('Atual path: ${Modular.to.path}', name: 'path');
    });

    controller.updateOnlineStatus(AppLifecycleState.resumed);

    friendsBloc.emit(FetchFriendsEvent());

    subscription = controller.stream().listen((messages) {
      chatsBloc.emit(LoadChatsEvent(messages));
    });

    groups = controller.groupsStream().listen((event) {
      log(event.length.toString());
    });
  }

  @override
  void dispose() {
    subscription.cancel();

    groups.cancel();

    WidgetsBinding.instance.removeObserver(this);

    controller.updateOnlineStatus(AppLifecycleState.inactive);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    await controller.updateOnlineStatus(state);
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
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add_rounded),
            )
          : null,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Theme.of(context).primaryColor,
        ),
        child: NavigationBar(
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
      ),
    );
  }
}

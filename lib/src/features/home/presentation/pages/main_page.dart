import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/features/home/presentation/pages/friends_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
          return Modular.to.navigate('/home');
        }
      case 1:
        {
          return Modular.to.navigate('/chats');
        }
      case 2:
        {
          return Modular.to.navigate('/feed');
        }
      case 3:
        {
          return Modular.to.navigate('/profile');
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const RouterOutlet(),
      bottomNavigationBar: NavigationBar(
        height: kToolbarHeight,
        selectedIndex: selected,
        onDestinationSelected: setSelected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.feed_outlined),
            selectedIcon: Icon(Icons.feed_rounded),
            label: 'Feed',
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

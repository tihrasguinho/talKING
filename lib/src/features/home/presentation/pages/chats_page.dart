import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => showModalBottomSheet(
      //     context: context,
      //     builder: (context) {
      //       return Column(
      //         children: [],
      //       );
      //     },
      //   ),
      //   child: const Icon(Icons.add_rounded),
      // ),
    );
  }
}

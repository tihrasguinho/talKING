import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/features/home/presentation/controllers/chats_controller.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final ChatsController controller = Modular.get();

  StreamSubscription<List<QueryDocumentSnapshot<Map<String, dynamic>>>>? subscription;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      subscription = controller.stream().listen((event) {
        log(event.length.toString());
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

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

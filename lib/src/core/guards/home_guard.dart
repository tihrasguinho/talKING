import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talking/src/features/home/home_module.dart';

class HomeGuard extends RouteGuard {
  HomeGuard() : super(redirectTo: '/auth/');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    await Modular.isModuleReady<HomeModule>();

    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user == null) {
      return false;
    } else {
      await Hive.box('app').put('uid', user.uid);

      return true;
    }
  }
}

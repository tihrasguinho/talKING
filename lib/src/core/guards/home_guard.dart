import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeGuard extends RouteGuard {
  HomeGuard() : super(redirectTo: '/auth/');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    final auth = FirebaseAuth.instance;

    return auth.currentUser != null ? true : false;
  }
}

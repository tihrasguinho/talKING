import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/chats');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    final auth = FirebaseAuth.instance;

    return auth.currentUser != null ? false : true;
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:talking/main_module.dart';
import 'package:talking/main_widget.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/utils/notifications_config.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(NotificationsConfig.firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationsConfig.initialize();

  await Hive.initFlutter();

  Hive.registerAdapter(UserEntityAdapter());

  await Hive.openBox<UserEntity>('friends');

  await Hive.openBox('app');

  await initializeDateFormatting('en_US');

  runApp(ModularApp(module: MainModule(), child: const MainWidget()));
}

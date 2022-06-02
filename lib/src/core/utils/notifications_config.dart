import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talking/firebase_options.dart';

import 'package:http/http.dart' as http;
import 'package:talking/src/core/enums/message_type.dart';
import 'package:talking/src/core/enums/notification_type.dart';
import 'package:talking/src/core/params/notification_params.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_event.dart';

class NotificationsConfig {
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('Permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    const initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_notification');

    const initializationSettingsIOS = IOSInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectnotification,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});

    FirebaseMessaging.onMessage.listen((message) async {
      log('New Notification', name: 'NotificationsConfig');

      final params = NotificationParams.fromMap(message.data);

      await _buildNotification(params);
    });
  }

  // On Select Notification
  static Future<void> _onSelectnotification(String? payload) async {
    final split = payload?.split(':') ?? [];

    if (split.length == 2) {
      if (split.first == 'new_message') {
        Modular.to.pushNamed(
          '/conversation/${split.last}',
          arguments: split.last,
        );

        return;
      }
    }
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    log('New Notification', name: 'NotificationsConfig');

    final params = NotificationParams.fromMap(message.data);

    await _buildNotification(params);
  }

  // Download notification icon
  static Future<String> _downloadAndSave(String url, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$filename';
    final response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<void> _buildNotification(NotificationParams params) async {
    switch (params.type) {
      case NotificationType.newMessage:
        {
          final path = Modular.to.path;

          if (path == '/conversation/${params.message['from']}') {
            return;
          }

          final type = MessageType.values.firstWhere((e) => e.desc == params.message['type']);

          switch (type) {
            case MessageType.text:
              {
                return await flutterLocalNotificationsPlugin.show(
                  params.hashCode,
                  params.notification['title'] ?? '',
                  params.notification['body'] ?? '',
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      'high_importance_channel',
                      'High Importance Notifications',
                      channelDescription: 'This channel is used for important notifications.',
                      priority: Priority.high,
                      importance: Importance.max,
                      largeIcon: params.notification['image'] != ''
                          ? FilePathAndroidBitmap(await _downloadAndSave(params.notification['image'], 'largeIcon'))
                          : null,
                    ),
                  ),
                  payload: 'new_message:${params.message['from']}',
                );
              }
            case MessageType.image:
              {
                final style = BigPictureStyleInformation(
                  FilePathAndroidBitmap(await _downloadAndSave(params.message['image'], 'bigPicture')),
                  largeIcon: FilePathAndroidBitmap(await _downloadAndSave(params.notification['image'], 'largeIcon')),
                  contentTitle: params.notification['title'] ?? '',
                  htmlFormatContentTitle: true,
                  summaryText: 'Sent you a picture',
                  htmlFormatSummaryText: true,
                );

                return await flutterLocalNotificationsPlugin.show(
                  params.hashCode,
                  params.notification['title'] ?? '',
                  params.notification['body'] ?? '',
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      'high_importance_channel',
                      'High Importance Notifications',
                      channelDescription: 'This channel is used for important notifications.',
                      priority: Priority.high,
                      importance: Importance.max,
                      largeIcon: params.notification['image'] != ''
                          ? FilePathAndroidBitmap(await _downloadAndSave(params.notification['image'], 'largeIcon'))
                          : null,
                      styleInformation: style,
                    ),
                  ),
                  payload: 'new_message:${params.message['from']}',
                );
              }
            case MessageType.audio:
              {
                break;
              }
            case MessageType.video:
              {
                break;
              }
          }

          break;
        }
      case NotificationType.friendRequest:
        {
          return await flutterLocalNotificationsPlugin.show(
            params.hashCode,
            params.notification['title'] ?? '',
            params.notification['body'] ?? '',
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription: 'This channel is used for important notifications.',
                priority: Priority.high,
                importance: Importance.max,
                largeIcon: params.notification['image'] != ''
                    ? FilePathAndroidBitmap(await _downloadAndSave(params.notification['image'], 'largeIcon'))
                    : null,
              ),
            ),
          );
        }
      case NotificationType.friendAccepted:
        {
          Modular.get<FriendsBloc>().emit(FetchFriendsEvent());

          return await flutterLocalNotificationsPlugin.show(
            params.hashCode,
            params.notification['title'] ?? '',
            params.notification['body'] ?? '',
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription: 'This channel is used for important notifications.',
                priority: Priority.high,
                importance: Importance.max,
                largeIcon: params.notification['image'] != ''
                    ? FilePathAndroidBitmap(await _downloadAndSave(params.notification['image'], 'largeIcon'))
                    : null,
              ),
            ),
          );
        }
    }
  }
}

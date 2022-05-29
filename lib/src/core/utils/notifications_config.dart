import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talking/firebase_options.dart';

import 'package:http/http.dart' as http;

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

      final notification = jsonDecode(message.data['notification']);

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification['title'] ?? '',
        notification['body'] ?? '',
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            largeIcon: FilePathAndroidBitmap(await _downloadAndSave(notification['image'], 'largeIcon')),
            styleInformation: await styleWithImage(message),
          ),
        ),
      );
    });
  }

  // On Select Notification
  static Future<void> _onSelectnotification(String? payload) async {}

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    log('New Notification', name: 'NotificationsConfig');

    final notification = jsonDecode(message.data['notification']);

    final android = jsonDecode(message.data['android']);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification['title'] ?? '',
      notification['body'] ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          largeIcon: FilePathAndroidBitmap(await _downloadAndSave(android['imageUrl'], 'largeIcon')),
        ),
      ),
    );
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

  // Notification with IMAGE
  static Future<BigPictureStyleInformation?> styleWithImage(RemoteMessage message) async {
    final notification = jsonDecode(message.data['notification']);
    final data = jsonDecode(message.data['message']);

    return data['type'] == 'image'
        ? BigPictureStyleInformation(
            FilePathAndroidBitmap(await _downloadAndSave(data['image'], 'bigPicture')),
            largeIcon: FilePathAndroidBitmap(await _downloadAndSave(notification['image'], 'largeIcon')),
            contentTitle: notification['title'] ?? '',
            htmlFormatContentTitle: true,
            summaryText: 'Sent you a picture',
            htmlFormatSummaryText: true,
          )
        : null;
  }
}

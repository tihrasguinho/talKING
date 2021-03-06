// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA1780Kr__B6ieiG15g8BHAkNK2BzqL5PU',
    appId: '1:975167234645:web:04146c706b6ff320fd6adc',
    messagingSenderId: '975167234645',
    projectId: 'talking-dev',
    authDomain: 'talking-dev.firebaseapp.com',
    storageBucket: 'talking-dev.appspot.com',
    measurementId: 'G-WQLZ1WZ844',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAacpJ7E9sdTZSpTC4a9gOOSMf57DjAgAo',
    appId: '1:975167234645:android:a1f21cef8d9c9fe3fd6adc',
    messagingSenderId: '975167234645',
    projectId: 'talking-dev',
    storageBucket: 'talking-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqH-IWU0WmdKQCedMUmIlOeNtmqsdOKH8',
    appId: '1:975167234645:ios:ffbdad954d7af384fd6adc',
    messagingSenderId: '975167234645',
    projectId: 'talking-dev',
    storageBucket: 'talking-dev.appspot.com',
    iosClientId: '975167234645-ubhqrm9ffa87fnijdoos06fp6ef5dtui.apps.googleusercontent.com',
    iosBundleId: 'dev.tihrasguinho.talking',
  );
}

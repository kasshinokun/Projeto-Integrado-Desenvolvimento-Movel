// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/*
Rode na pasta da aplicação(run terminal on app folder) os seguintes comandos:
-->dart pub global activate flutterfire_cli   
-->flutterfire configure --project=<project_id>
*/
//-----------------------------------------------------------
//To EN-US
//If you speak english, where it says "sua" it means "your"
//-----------------------------------------------------------

//PT-BR
const String projectId = 'sua-project-id';
const String messagingSenderId = 'sua-messaging-Sender-Id';

const String tokenWeb = 'sua-flutterfire-token-web';
const String tokenAndroid = 'sua-flutterfire-token-android';
const String tokenWindows = 'sua-flutterfire-token-windows';

const String apiKeyWeb = 'sua-flutterfire-api-key-web';
const String apiKeyAndroid = 'sua-flutterfire-api-key-android';
const String apiKeyWindows = 'sua-flutterfire-api-key-windows';

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: apiKeyWeb,
    appId: '1:' + messagingSenderId + ':web:' + tokenWeb,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    authDomain: projectId + '.firebaseapp.com',
    databaseURL: 'https://' + projectId + '-default-rtdb.firebaseio.com',
    storageBucket: projectId + '.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: apiKeyAndroid,
    appId: '1:' + messagingSenderId + ':android:' + tokenAndroid,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    databaseURL: 'https://' + projectId + '-default-rtdb.firebaseio.com',
    storageBucket: projectId + '.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: apiKeyWindows,
    appId: '1:' + messagingSenderId + ':web:' + tokenWindows,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    authDomain: projectId + '.firebaseapp.com',
    databaseURL: 'https://' + projectId + '-default-rtdb.firebaseio.com',
    storageBucket: projectId + '.firebasestorage.app',
  );
}

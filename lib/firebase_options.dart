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
        return macos;
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
    apiKey: 'AIzaSyAh42L1qfI4TsXosUJbv6sYEV9HklIA9b4',
    appId: '1:113195666098:web:99239db7c856c450fed7ab',
    messagingSenderId: '113195666098',
    projectId: 'ryamworkspace',
    authDomain: 'ryamworkspace.firebaseapp.com',
    storageBucket: 'ryamworkspace.appspot.com',
    measurementId: 'G-E2HPRXFGCD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOBSRlnkcZMZs8kncnjHV21TLFEJ0_aVQ',
    appId: '1:113195666098:android:78e5d7d14e0f15d9fed7ab',
    messagingSenderId: '113195666098',
    projectId: 'ryamworkspace',
    storageBucket: 'ryamworkspace.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbhx12iwcppZtxAbnIZO2oVTds4zLB1pk',
    appId: '1:113195666098:ios:a13af65d610d67ddfed7ab',
    messagingSenderId: '113195666098',
    projectId: 'ryamworkspace',
    storageBucket: 'ryamworkspace.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbhx12iwcppZtxAbnIZO2oVTds4zLB1pk',
    appId: '1:113195666098:ios:a13af65d610d67ddfed7ab',
    messagingSenderId: '113195666098',
    projectId: 'ryamworkspace',
    storageBucket: 'ryamworkspace.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );
}

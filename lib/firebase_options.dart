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
    apiKey: 'AIzaSyDMmhcrCvqFSpehdc9aZuzQrK3ilpCeS9M',
    appId: '1:757645374852:web:e79a8be2708dde383059d1',
    messagingSenderId: '757645374852',
    projectId: 'ticket-booking-3d4ff',
    authDomain: 'ticket-booking-3d4ff.firebaseapp.com',
    storageBucket: 'ticket-booking-3d4ff.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFiv5RyoNV-nBdWUcLILo-gsbsCmZ-AWM',
    appId: '1:757645374852:android:24e592c37ea3fe0d3059d1',
    messagingSenderId: '757645374852',
    projectId: 'ticket-booking-3d4ff',
    storageBucket: 'ticket-booking-3d4ff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOeYl1LjWCVMIP1q9EQX1OCD5-eeqREB8',
    appId: '1:757645374852:ios:04ae38e44f8b74ed3059d1',
    messagingSenderId: '757645374852',
    projectId: 'ticket-booking-3d4ff',
    storageBucket: 'ticket-booking-3d4ff.appspot.com',
    iosBundleId: 'com.example.ticketBooking',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOeYl1LjWCVMIP1q9EQX1OCD5-eeqREB8',
    appId: '1:757645374852:ios:8f89f66d2932e9773059d1',
    messagingSenderId: '757645374852',
    projectId: 'ticket-booking-3d4ff',
    storageBucket: 'ticket-booking-3d4ff.appspot.com',
    iosBundleId: 'com.example.ticketBooking.RunnerTests',
  );
}

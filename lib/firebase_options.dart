// File generated from Firebase Console configuration
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
    apiKey: 'AIzaSyCYRJY5Wyx44mWwtgmatq93zv_Cs_Hq1mU',
    appId: '1:629247023515:web:c4294ae7116fea79c4a93e',
    messagingSenderId: '629247023515',
    projectId: 'ureshii-partner-app',
    authDomain: 'ureshii-partner-app.firebaseapp.com',
    storageBucket: 'ureshii-partner-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYRJY5Wyx44mWwtgmatq93zv_Cs_Hq1mU',
    appId: '1:629247023515:android:c4294ae7116fea79c4a93e',
    messagingSenderId: '629247023515',
    projectId: 'ureshii-partner-app',
    authDomain: 'ureshii-partner-app.firebaseapp.com',
    storageBucket: 'ureshii-partner-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYRJY5Wyx44mWwtgmatq93zv_Cs_Hq1mU',
    appId: '1:629247023515:ios:c4294ae7116fea79c4a93e',
    messagingSenderId: '629247023515',
    projectId: 'ureshii-partner-app',
    authDomain: 'ureshii-partner-app.firebaseapp.com',
    storageBucket: 'ureshii-partner-app.firebasestorage.app',
    iosBundleId: 'com.example.flutterApp',
  );
}

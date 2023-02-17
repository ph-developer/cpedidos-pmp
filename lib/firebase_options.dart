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
    apiKey: 'AIzaSyDx5qT5oe81v_6fRKRGmVGNUa6nrrAlfWw',
    appId: '1:1083881374343:web:96410eea8d5a201c636e22',
    messagingSenderId: '1083881374343',
    projectId: 'cpedidos-pmp',
    authDomain: 'cpedidos-pmp.firebaseapp.com',
    databaseURL: 'https://cpedidos-pmp-default-rtdb.firebaseio.com',
    storageBucket: 'cpedidos-pmp.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9aaWzCR4goea0b5c_wOOTzOeZGAiXeCQ',
    appId: '1:1083881374343:android:ebe0f155ed13005d636e22',
    messagingSenderId: '1083881374343',
    projectId: 'cpedidos-pmp',
    databaseURL: 'https://cpedidos-pmp-default-rtdb.firebaseio.com',
    storageBucket: 'cpedidos-pmp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB9vF1q-Hze3kGnCSRATGlOIg3Cj-8LdfM',
    appId: '1:1083881374343:ios:420e19dd70b883a5636e22',
    messagingSenderId: '1083881374343',
    projectId: 'cpedidos-pmp',
    databaseURL: 'https://cpedidos-pmp-default-rtdb.firebaseio.com',
    storageBucket: 'cpedidos-pmp.appspot.com',
    iosClientId: '1083881374343-a0149pof3cupehapbcaa4m3qmdj67ljj.apps.googleusercontent.com',
    iosBundleId: 'com.example.cpedidosPmp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB9vF1q-Hze3kGnCSRATGlOIg3Cj-8LdfM',
    appId: '1:1083881374343:ios:420e19dd70b883a5636e22',
    messagingSenderId: '1083881374343',
    projectId: 'cpedidos-pmp',
    databaseURL: 'https://cpedidos-pmp-default-rtdb.firebaseio.com',
    storageBucket: 'cpedidos-pmp.appspot.com',
    iosClientId: '1083881374343-a0149pof3cupehapbcaa4m3qmdj67ljj.apps.googleusercontent.com',
    iosBundleId: 'com.example.cpedidosPmp',
  );
}

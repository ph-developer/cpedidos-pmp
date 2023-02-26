import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.g.dart';

abstract class FirebaseConfig {
  static Future<void> setup() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kDebugMode && const bool.fromEnvironment('USE_FIREBASE_EMULATORS')) {
      FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    }

    await FirebaseAuth.instance.authStateChanges().first;
  }
}

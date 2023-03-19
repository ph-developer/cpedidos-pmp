import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import 'firebase_options.g.dart';

abstract class FirebaseBoot {
  static Future<void> run({bool useEmulators = false}) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (const bool.fromEnvironment('USE_FIREBASE_EMULATORS') || useEmulators) {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

      if (kDebugMode && kIsWeb) {
        try {
          await _restoreSession();
          FirebaseAuth.instance.authStateChanges().listen(_saveSession);
        } catch (e) {
          html.window.location.reload();
        }
      }
    }

    await FirebaseAuth.instance.authStateChanges().first;
  }

  static Future<void> _saveSession(User? user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('EMULATORS:IS_LOGGED_IN', user != null);
  }

  static Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('EMULATORS:IS_LOGGED_IN') == true) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@test.dev',
        password: 'password',
      );
      await FirebaseAuth.instance.authStateChanges().first;
    }
  }
}

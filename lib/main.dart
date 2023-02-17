import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'firebase_options.dart';
import 'injector.dart';
import 'router.dart';
import 'src/app_widget.dart';
import 'src/auth/presentation/cubits/auth_cubit.dart';
import 'src/auth/presentation/cubits/auth_state.dart';
import 'src/boot_widget.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // usePathUrlStrategy();

  runApp(BootWidget(widgetsBinding: widgetsBinding));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);
      FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  setupInjector();

  final authCubit = inject<AuthCubit>();

  authCubit.fetchLoggedUser();
  authCubit.stream
      .firstWhere(
          (state) => state is AuthLoggedInState || state is AuthLoggedOutState)
      .then(
    (state) async {
      if (state is AuthLoggedInState) {
        setupRouter('/pedidos/cadastro');
      } else if (state is AuthLoggedOutState) {
        setupRouter('/login');
      }

      await Future.delayed(const Duration(seconds: 1));

      runApp(const AppWidget());
    },
  );
}

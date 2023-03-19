import 'package:flutter/foundation.dart';

import '../../../features/auth/presentation/stores/auth_store.dart';
import '../../injection/injector.dart';

abstract class AuthBoot {
  @visibleForTesting
  static AuthStore? authStore;

  static Future<void> run() async {
    final authStore = AuthBoot.authStore ?? inject<AuthStore>();
    await authStore.fetchLoggedUser();
  }
}

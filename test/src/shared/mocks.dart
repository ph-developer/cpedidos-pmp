import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MockSentryClient extends Mock implements SentryClient {}

abstract class Callable<T> {
  void call([T? arg]) {}
}

class MockCallable<T> extends Mock implements Callable<T> {}

class MockFirebaseApp extends Mock implements FirebaseApp {}

class MockFirebasePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {}

class MockFirebaseAppPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebaseAppPlatform {}

class MockFirebaseAuthPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebaseAuthPlatform {}

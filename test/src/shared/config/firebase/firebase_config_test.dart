// ignore_for_file: invalid_use_of_protected_member

import 'package:cpedidos_pmp/src/shared/config/firebase/firebase_config.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    hide MockFirebaseApp;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseApp mockFirebaseApp;
  late FirebasePlatform mockFirebasePlatform;
  late FirebaseAppPlatform mockFirebaseAppPlatform;
  late FirebaseAuthPlatform mockFirebaseAuthPlatform;

  setUp(() {
    mockFirebaseApp = MockFirebaseApp();
    mockFirebasePlatform = MockFirebasePlatform();
    mockFirebaseAppPlatform = MockFirebaseAppPlatform();
    mockFirebaseAuthPlatform = MockFirebaseAuthPlatform();
    Firebase.delegatePackingProperty = mockFirebasePlatform;
    FirebaseAuthPlatform.instance = mockFirebaseAuthPlatform;

    registerFallbackValue(mockFirebaseApp);

    when(
      () => mockFirebasePlatform.initializeApp(
        name: any(named: 'name'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => mockFirebaseAppPlatform);
    when(() => mockFirebasePlatform.app(any()))
        .thenReturn(mockFirebaseAppPlatform);
    when(() => mockFirebaseAppPlatform.name).thenReturn('name');
    when(
      () => mockFirebaseAuthPlatform.delegateFor(
        app: any(named: 'app'),
        persistence: any(named: 'persistence'),
      ),
    ).thenReturn(mockFirebaseAuthPlatform);
    when(
      () => mockFirebaseAuthPlatform.setInitialValues(
        languageCode: any(named: 'languageCode'),
        currentUser: any(named: 'currentUser'),
      ),
    ).thenReturn(mockFirebaseAuthPlatform);
    when(() => mockFirebaseAuthPlatform.useAuthEmulator(any(), any()))
        .thenAnswer((_) async => {});
    when(() => mockFirebaseAuthPlatform.authStateChanges())
        .thenAnswer((_) => Stream.fromIterable(<UserPlatform?>[null]));
  });

  group('setup', () {
    test(
      'should initialize firebase without emulators without errors.',
      () async {
        // act
        await FirebaseConfig.setup();
        // assert
        expect(kDebugMode, isTrue);
        expect(const bool.fromEnvironment('USE_FIREBASE_EMULATORS'), isFalse);
      },
    );

    test(
      'should initialize firebase with emulators without errors.',
      () async {
        // arrange //? Only to hide emulators prints
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        // act
        await FirebaseConfig.setup(useEmulators: true);
        // assert
        expect(kDebugMode, isTrue);
        expect(const bool.fromEnvironment('USE_FIREBASE_EMULATORS'), isFalse);
      },
    );
  });
}

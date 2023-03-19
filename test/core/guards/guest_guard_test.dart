import 'package:cpedidos_pmp/core/guards/guest_guard.dart';
import 'package:cpedidos_pmp/core/injection/injector.dart';
import 'package:cpedidos_pmp/features/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/features/auth/presentation/stores/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  final AuthStore mockAuthStore = MockAuthStore();
  final BuildContext mockBuildContext = MockBuildContext();
  final GoRouterState mockGoRouterState = MockGoRouterState();

  setupInjector((injector) async {
    injector
      ..addInstance<AuthStore>(mockAuthStore)
      ..commit();
  });

  const tUser = LoggedUser(id: 'id', email: 'email');

  test(
    'should return null when user is logged out.',
    () async {
      // arrange
      when(() => mockAuthStore.isLoading).thenReturn(false);
      when(() => mockAuthStore.loggedUser).thenReturn(null);
      // act
      final result = await guestGuard(mockBuildContext, mockGoRouterState);
      // assert
      expect(result, isNull);
    },
  );

  test(
    'should return "/pedidos/cadastro" when user is logged in.',
    () async {
      // arrange
      when(() => mockAuthStore.isLoading).thenReturn(false);
      when(() => mockAuthStore.loggedUser).thenReturn(tUser);
      // act
      final result = await guestGuard(mockBuildContext, mockGoRouterState);
      // assert
      expect(result, equals('/pedidos/cadastro'));
    },
  );

  test(
    'should wait load auth store before continue.',
    () async {
      // arrange
      when(() => mockAuthStore.isLoading).thenAnswer((_) {
        when(() => mockAuthStore.isLoading).thenReturn(false);
        return true;
      });
      when(() => mockAuthStore.loggedUser).thenReturn(null);
      // act
      final result = await guestGuard(mockBuildContext, mockGoRouterState);
      // assert
      expect(result, isNull);
    },
  );
}

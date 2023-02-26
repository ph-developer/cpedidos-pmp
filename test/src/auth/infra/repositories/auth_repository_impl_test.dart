import 'package:cpedidos_pmp/src/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/infra/datasources/auth_datasource.dart';
import 'package:cpedidos_pmp/src/auth/infra/models/logged_user_model.dart';
import 'package:cpedidos_pmp/src/auth/infra/repositories/auth_repository_impl.dart';
import 'package:cpedidos_pmp/src/shared/services/error_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../mocks.dart';

void main() {
  late IErrorService mockErrorService;
  late IAuthDatasource mockAuthDatasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockErrorService = MockErrorService();
    mockAuthDatasource = MockAuthDatasource();
    repository = AuthRepositoryImpl(mockErrorService, mockAuthDatasource);
  });

  const tId = 'id';
  const tEmail = 'test@test.dev';
  const tPassword = 'password';
  const tLoggedUserModel = LoggedUserModel(id: tId, email: tEmail);
  final tAuthFailure = MockAuthFailure();

  group('login', () {
    test(
      'should return a LoggedUserModel when login with success.',
      () async {
        // arrange
        when(() => mockAuthDatasource.login(tEmail, tPassword))
            .thenAnswer((_) async => tLoggedUserModel);
        // act
        final result = await repository.login(tEmail, tPassword);
        // assert
        expect(result.getOrNull(), equals(tLoggedUserModel));
      },
    );

    test(
      'should return a known failure when datasource throws a known failure.',
      () async {
        // arrange
        when(() => mockAuthDatasource.login(tEmail, tPassword))
            .thenThrow(tAuthFailure);
        // act
        final result = await repository.login(tEmail, tPassword);
        // assert
        expect(result.exceptionOrNull(), equals(tAuthFailure));
      },
    );

    test(
      'should report exception and return a failure on unknown exception.',
      () async {
        // arrange
        final tException = Exception('unknown');
        when(() => mockAuthDatasource.login(tEmail, tPassword))
            .thenThrow(tException);
        when(() => mockErrorService.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await repository.login(tEmail, tPassword);
        // assert
        verify(() => mockErrorService.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), isA<UnknownError>());
      },
    );
  });

  group('logout', () {
    test(
      'should return an unit when logout with success.',
      () async {
        // arrange
        when(() => mockAuthDatasource.logout()).thenAnswer((_) async => true);
        // act
        final result = await repository.logout();
        // assert
        expect(result.getOrNull(), equals(unit));
      },
    );

    test(
      'should return a known failure when datasource throws a known failure.',
      () async {
        // arrange
        when(() => mockAuthDatasource.logout()).thenThrow(tAuthFailure);
        // act
        final result = await repository.logout();
        // assert
        expect(result.exceptionOrNull(), equals(tAuthFailure));
      },
    );

    test(
      'should report exception and return a failure on unknown exception.',
      () async {
        // arrange
        final tException = Exception('unknown');
        when(() => mockAuthDatasource.logout()).thenThrow(tException);
        when(() => mockErrorService.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await repository.logout();
        // assert
        verify(() => mockErrorService.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), isA<UnknownError>());
      },
    );
  });

  group('getCurrentUser', () {
    test(
      'should return a LoggedUserModel when user is logged in.',
      () async {
        // arrange
        when(() => mockAuthDatasource.getCurrentUser())
            .thenAnswer((_) async => tLoggedUserModel);
        // act
        final result = await repository.getCurrentUser();
        // assert
        expect(result.getOrNull(), equals(tLoggedUserModel));
      },
    );

    test(
      'should return a known failure when datasource throws a known failure.',
      () async {
        // arrange
        when(() => mockAuthDatasource.getCurrentUser()).thenThrow(tAuthFailure);
        // act
        final result = await repository.getCurrentUser();
        // assert
        expect(result.exceptionOrNull(), equals(tAuthFailure));
      },
    );

    test(
      'should report exception and return a failure on unknown exception.',
      () async {
        // arrange
        final tException = Exception('unknown');
        when(() => mockAuthDatasource.getCurrentUser()).thenThrow(tException);
        when(() => mockErrorService.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await repository.getCurrentUser();
        // assert
        verify(() => mockErrorService.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), isA<UnknownError>());
      },
    );
  });
}

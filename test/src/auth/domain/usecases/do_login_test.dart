import 'package:cpedidos_pmp/src/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/src/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repository.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../mocks.dart';

void main() {
  late IAuthRepository mockAuthRepository;
  late DoLogin usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = DoLogin(mockAuthRepository);
  });

  final tAuthFailure = MockAuthFailure();
  const tLoggedUser = LoggedUser(id: 'id', email: 'email@example.com');

  test(
    'should return a LoggedUser on successfull login.',
    () async {
      // arrange
      const tUserEmail = 'email@example.com';
      const tUserPassword = '1234';
      when(() => mockAuthRepository.login(tUserEmail, tUserPassword))
          .thenAnswer((_) async => const Success(tLoggedUser));
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result.getOrNull(), equals(tLoggedUser));
    },
  );

  test(
    'should return an InvalidInput failure when email param is empty.',
    () async {
      // arrange
      const tUserEmail = '';
      const tUserPassword = '1234';
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when password param is empty.',
    () async {
      // arrange
      const tUserEmail = 'email@example.com';
      const tUserPassword = '';
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when email param is invalid.',
    () async {
      // arrange
      const tUserEmail = 'invalid_email';
      const tUserPassword = '1234';
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return a failure when repository returns a failure.',
    () async {
      // arrange
      const tUserEmail = 'email@example.com';
      const tUserPassword = '1234';
      when(() => mockAuthRepository.login(tUserEmail, tUserPassword))
          .thenAnswer((_) async => Failure(tAuthFailure));
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result.exceptionOrNull(), equals(tAuthFailure));
    },
  );
}

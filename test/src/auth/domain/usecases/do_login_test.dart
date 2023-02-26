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
  const tEmail = 'test@test.dev';
  const tPassword = 'password';
  const tLoggedUser = LoggedUser(id: 'id', email: tEmail);

  test(
    'should return a LoggedUser on successfull login.',
    () async {
      // arrange
      when(() => mockAuthRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => const Success(tLoggedUser));
      // act
      final result = await usecase(tEmail, tPassword);
      // assert
      expect(result.getOrNull(), equals(tLoggedUser));
    },
  );

  test(
    'should return an InvalidInput failure when email param is empty.',
    () async {
      // act
      final result = await usecase('', tPassword);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when password param is empty.',
    () async {
      // act
      final result = await usecase(tEmail, '');
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when email param is invalid.',
    () async {
      // act
      final result = await usecase('invalid', tPassword);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return a failure when repository returns a failure.',
    () async {
      // arrange
      when(() => mockAuthRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => Failure(tAuthFailure));
      // act
      final result = await usecase(tEmail, tPassword);
      // assert
      expect(result.exceptionOrNull(), equals(tAuthFailure));
    },
  );
}

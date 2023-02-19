import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import 'package:cpedidos_pmp/src/auth/domain/entities/user.dart';
import 'package:cpedidos_pmp/src/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/user_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_login.dart';

class MockAuthRepo extends Mock implements IAuthRepo {}

class MockUserRepo extends Mock implements IUserRepo {}

class MockAuthFailure extends Mock implements AuthFailure {}

void main() {
  late IAuthRepo mockAuthRepo;
  late IUserRepo mockUserRepo;
  late DoLogin usecase;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    mockUserRepo = MockUserRepo();
    usecase = DoLogin(mockAuthRepo, mockUserRepo);
  });

  final tAuthFailure = MockAuthFailure();
  const tUserId = 'id';
  const tUser = User(id: 'id', email: 'email@example.com', name: 'name');

  test(
    'should return an User on successfull login.',
    () async {
      // arrange
      const tUserEmail = 'email@example.com';
      const tUserPassword = '1234';
      when(() => mockAuthRepo.login(tUserEmail, tUserPassword))
          .thenAnswer((_) async => const Success(tUserId));
      when(() => mockUserRepo.getById(tUserId))
          .thenAnswer((_) async => const Success(tUser));
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result.getOrNull(), equals(tUser));
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
    'should return an auth failure when auth repo returns an auth failure.',
    () async {
      // arrange
      const tUserEmail = 'email@example.com';
      const tUserPassword = '1234';
      when(() => mockAuthRepo.login(tUserEmail, tUserPassword))
          .thenAnswer((_) async => Failure(tAuthFailure));
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result.exceptionOrNull(), equals(tAuthFailure));
    },
  );
}

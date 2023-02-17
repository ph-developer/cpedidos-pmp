import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cpedidos_pmp/src/auth/data/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/domain/entities/user.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/user_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_login.dart';

class MockAuthRepo extends Mock implements IAuthRepo {}

class MockUserRepo extends Mock implements IUserRepo {}

void main() {
  late IAuthRepo mockAuthRepo;
  late IUserRepo mockUserRepo;
  late DoLogin usecase;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    mockUserRepo = MockUserRepo();
    usecase = DoLogin(mockAuthRepo, mockUserRepo);
  });

  test(
    'should return an user on successfull login.',
    () async {
      // arrange
      const tUserEmail = 'email@example.com';
      const tUserPassword = '1234';
      const tUserId = 'id';
      const tUser = User(id: 'id', email: 'email@example.com', name: 'name');
      when(() => mockAuthRepo.login(tUserEmail, tUserPassword))
          .thenAnswer((_) async => tUserId);
      when(() => mockUserRepo.getById(tUserId)).thenAnswer((_) async => tUser);
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result, equals(tUser));
    },
  );

  test(
    'should return null when email param is empty.',
    () async {
      // arrange
      const tUserEmail = '';
      const tUserPassword = '1234';
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result, isNull);
    },
  );

  test(
    'should return null when password param is empty.',
    () async {
      // arrange
      const tUserEmail = 'email@example.com';
      const tUserPassword = '';
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result, isNull);
    },
  );

  test(
    'should return null when email param is invalid.',
    () async {
      // arrange
      const tUserEmail = 'invalid_email';
      const tUserPassword = '1234';
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result, isNull);
    },
  );

  test(
    'should return null when auth repo throws a Failure.',
    () async {
      // arrange
      const tUserEmail = 'email@example.com';
      const tUserPassword = '1234';
      final failure = LoginFailure();
      when(() => mockAuthRepo.login(tUserEmail, tUserPassword))
          .thenThrow(failure);
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result, isNull);
    },
  );

  test(
    'should return null when user repo throws a Failure.',
    () async {
      // arrange
      const tUserEmail = 'email@example.com';
      const tUserPassword = '1234';
      const tUserId = 'id';
      final failure = GetUserFailure();
      when(() => mockAuthRepo.login(tUserEmail, tUserPassword))
          .thenAnswer((_) async => tUserId);
      when(() => mockUserRepo.getById(tUserId)).thenThrow(failure);
      // act
      final result = await usecase(tUserEmail, tUserPassword);
      // assert
      expect(result, isNull);
    },
  );
}

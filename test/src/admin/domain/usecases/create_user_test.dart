import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import 'package:cpedidos_pmp/src/admin/domain/entities/user.dart';
import 'package:cpedidos_pmp/src/admin/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/admin/domain/repositories/user_repo.dart';
import 'package:cpedidos_pmp/src/admin/domain/usecases/create_user.dart';

class MockUserRepo extends Mock implements IUserRepo {}

class MockAdminFailure extends Mock implements AdminFailure {}

void main() {
  late IUserRepo mockUserRepo;
  late CreateUser usecase;

  setUp(() {
    mockUserRepo = MockUserRepo();
    usecase = CreateUser(mockUserRepo);
  });

  final tAdminFailure = MockAdminFailure();

  test(
    'should return an user on successfull creation.',
    () async {
      // arrange
      const tUserParam = User(email: 'email@example.com', name: 'name');
      when(() => mockUserRepo.create(tUserParam))
          .thenAnswer((_) async => const Success(tUserParam));
      // act
      final result = await usecase(tUserParam);
      // assert
      expect(result.getOrNull(), equals(tUserParam));
    },
  );

  test(
    'should return an InvalidInput failure when user email param is empty.',
    () async {
      // arrange
      const tUserParam = User(email: '', name: 'name');
      // act
      final result = await usecase(tUserParam);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when user name param is empty.',
    () async {
      // arrange
      const tUserParam = User(email: 'email@example.com', name: '');
      // act
      final result = await usecase(tUserParam);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when user email param is invalid.',
    () async {
      // arrange
      const tUserParam = User(email: 'invalid_email', name: 'name');
      // act
      final result = await usecase(tUserParam);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an admin failure when user repo returns an admin failure.',
    () async {
      // arrange
      const tUserParam = User(email: 'email@example.com', name: 'name');
      when(() => mockUserRepo.create(tUserParam))
          .thenAnswer((_) async => Failure(tAdminFailure));
      // act
      final result = await usecase(tUserParam);
      // assert
      expect(result.exceptionOrNull(), equals(tAdminFailure));
    },
  );
}

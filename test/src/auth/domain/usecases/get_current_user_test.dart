import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cpedidos_pmp/src/auth/data/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/domain/entities/user.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/user_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/get_current_user.dart';

class MockAuthRepo extends Mock implements IAuthRepo {}

class MockUserRepo extends Mock implements IUserRepo {}

void main() {
  late IAuthRepo mockAuthRepo;
  late IUserRepo mockUserRepo;
  late GetCurrentUser usecase;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    mockUserRepo = MockUserRepo();
    usecase = GetCurrentUser(mockAuthRepo, mockUserRepo);
  });

  test(
    'should return null when user is not logget in.',
    () async {
      // arrange
      when(() => mockAuthRepo.getCurrentUserId()).thenAnswer((_) async => null);
      // act
      final result = await usecase();
      // assert
      expect(result, isNull);
    },
  );

  test(
    'should return user when user is logged in.',
    () async {
      // arrange
      const tUserId = 'id';
      const tUser = User(id: 'id', email: 'email@example.com', name: 'name');
      when(() => mockAuthRepo.getCurrentUserId()).thenAnswer((_) async => 'id');
      when(() => mockUserRepo.getById(tUserId)).thenAnswer((_) async => tUser);
      // act
      final result = await usecase();
      // assert
      expect(result, tUser);
    },
  );

  test(
    'should return null when user repo throws a Failure.',
    () async {
      // arrange
      const tUserId = 'id';
      final failure = GetUserFailure();
      when(() => mockAuthRepo.getCurrentUserId())
          .thenAnswer((_) async => tUserId);
      when(() => mockUserRepo.getById(tUserId)).thenThrow(failure);
      // act
      final result = await usecase();
      // assert
      expect(result, isNull);
    },
  );
}

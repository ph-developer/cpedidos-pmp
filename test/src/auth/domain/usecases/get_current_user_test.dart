import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import 'package:cpedidos_pmp/src/auth/domain/entities/user.dart';
import 'package:cpedidos_pmp/src/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/user_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/get_current_user.dart';

class MockAuthRepo extends Mock implements IAuthRepo {}

class MockUserRepo extends Mock implements IUserRepo {}

class MockAuthFailure extends Mock implements AuthFailure {}

void main() {
  late IAuthRepo mockAuthRepo;
  late IUserRepo mockUserRepo;
  late GetCurrentUser usecase;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    mockUserRepo = MockUserRepo();
    usecase = GetCurrentUser(mockAuthRepo, mockUserRepo);
  });

  final tAuthFailure = MockAuthFailure();

  test(
    'should return an User when user is logged in.',
    () async {
      // arrange
      const tUserId = 'id';
      const tUser = User(id: 'id', email: 'email@example.com', name: 'name');
      when(() => mockAuthRepo.getCurrentUserId())
          .thenAnswer((_) async => const Success('id'));
      when(() => mockUserRepo.getById(tUserId))
          .thenAnswer((_) async => const Success(tUser));
      // act
      final result = await usecase();
      // assert
      expect(result.getOrNull(), equals(tUser));
    },
  );

  test(
    'should return an auth failure when auth repo returns an auth failure.',
    () async {
      // arrange
      const tUserId = 'id';
      when(() => mockAuthRepo.getCurrentUserId())
          .thenAnswer((_) async => const Success(tUserId));
      when(() => mockUserRepo.getById(tUserId))
          .thenAnswer((_) async => Failure(tAuthFailure));
      // act
      final result = await usecase();
      // assert
      expect(result.exceptionOrNull(), equals(tAuthFailure));
    },
  );
}

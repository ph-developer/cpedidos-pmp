import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import 'package:cpedidos_pmp/src/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_logout.dart';

class MockAuthRepo extends Mock implements IAuthRepo {}

class MockAuthFailure extends Mock implements AuthFailure {}

void main() {
  late IAuthRepo mockAuthRepo;
  late DoLogout usecase;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    usecase = DoLogout(mockAuthRepo);
  });

  final tAuthFailure = MockAuthFailure();

  test(
    'should return true on successfull logout.',
    () async {
      // arrange
      when(() => mockAuthRepo.logout())
          .thenAnswer((_) async => const Success(true));
      // act
      final result = await usecase();
      // assert
      expect(result.getOrNull(), isTrue);
    },
  );

  test(
    'should return false on failed logout.',
    () async {
      // arrange
      when(() => mockAuthRepo.logout())
          .thenAnswer((_) async => const Success(false));
      // act
      final result = await usecase();
      // assert
      expect(result.getOrNull(), isFalse);
    },
  );

  test(
    'should return false when auth repo throws a Failure.',
    () async {
      // arrange
      when(() => mockAuthRepo.logout())
          .thenAnswer((_) async => Failure(tAuthFailure));
      // act
      final result = await usecase();
      // assert
      expect(result.exceptionOrNull(), equals(tAuthFailure));
    },
  );
}

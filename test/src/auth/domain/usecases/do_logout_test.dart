import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cpedidos_pmp/src/auth/data/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_logout.dart';

class MockAuthRepo extends Mock implements IAuthRepo {}

void main() {
  late IAuthRepo mockAuthRepo;
  late DoLogout usecase;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    usecase = DoLogout(mockAuthRepo);
  });

  test(
    'should return true on successfull logout.',
    () async {
      // arrange
      when(() => mockAuthRepo.logout()).thenAnswer((_) async => true);
      // act
      final result = await usecase();
      // assert
      expect(result, isTrue);
    },
  );

  test(
    'should return false on failed logout.',
    () async {
      // arrange
      when(() => mockAuthRepo.logout()).thenAnswer((_) async => false);
      // act
      final result = await usecase();
      // assert
      expect(result, isFalse);
    },
  );

  test(
    'should return false when auth repo throws a Failure.',
    () async {
      // arrange
      final failure = LogoutFailure();
      when(() => mockAuthRepo.logout()).thenThrow(failure);
      // act
      final result = await usecase();
      // assert
      expect(result, isFalse);
    },
  );
}

import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repository.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_logout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../mocks.dart';

void main() {
  late IAuthRepository mockAuthRepository;
  late DoLogout usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = DoLogout(mockAuthRepository);
  });

  final tAuthFailure = MockAuthFailure();

  test(
    'should return an unit on successfull logout.',
    () async {
      // arrange
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Success(unit));
      // act
      final result = await usecase();
      // assert
      expect(result.getOrNull(), equals(unit));
    },
  );

  test(
    'should return a failure when repository returns a failure.',
    () async {
      // arrange
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => Failure(tAuthFailure));
      // act
      final result = await usecase();
      // assert
      expect(result.exceptionOrNull(), equals(tAuthFailure));
    },
  );
}

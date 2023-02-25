import 'package:cpedidos_pmp/src/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repository.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../mocks.dart';

void main() {
  late IAuthRepository mockAuthRepository;
  late GetCurrentUser usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUser(mockAuthRepository);
  });

  final tAuthFailure = MockAuthFailure();
  const tLoggedUser = LoggedUser(id: 'id', email: 'email@example.com');

  test(
    'should return a LoggedUser when user is logged in.',
    () async {
      // arrange
      when(() => mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => const Success(tLoggedUser));
      // act
      final result = await usecase();
      // assert
      expect(result.getOrNull(), equals(tLoggedUser));
    },
  );

  test(
    'should return a failure when repository returns a failure.',
    () async {
      // arrange
      when(() => mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => Failure(tAuthFailure));
      // act
      final result = await usecase();
      // assert
      expect(result.exceptionOrNull(), equals(tAuthFailure));
    },
  );
}

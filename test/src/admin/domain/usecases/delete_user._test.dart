import 'package:cpedidos_pmp/src/admin/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/admin/domain/repositories/user_repository.dart';
import 'package:cpedidos_pmp/src/admin/domain/usecases/delete_user..dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late IUserRepository mockUserRepository;
  late DeleteUserImpl usecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = DeleteUserImpl(mockUserRepository);
  });

  const tId = 'id';

  test(
    'should return true on successfull deletion.',
    () async {
      // arrange
      when(() => mockUserRepository.deleteUser(tId))
          .thenAnswer((_) async => const Success(true));
      // act
      final result = await usecase(tId);
      // assert
      expect(result.getOrNull(), isTrue);
    },
  );

  test(
    'should return an idCantBeEmpty failure when id is empty.',
    () async {
      // act
      final result = await usecase('');
      // assert
      expect(result.exceptionOrNull(), equals(AdminFailure.idCantBeEmpty));
    },
  );

  test(
    'should return a failure when user repository returns a failure.',
    () async {
      // arrange
      const tFailure = AdminFailure.unknownError;
      when(() => mockUserRepository.deleteUser(tId))
          .thenAnswer((_) async => const Failure(tFailure));
      // act
      final result = await usecase(tId);
      // assert
      expect(result.exceptionOrNull(), equals(tFailure));
    },
  );
}

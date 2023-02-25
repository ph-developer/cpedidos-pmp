import 'package:cpedidos_pmp/src/admin/domain/entities/user.dart';
import 'package:cpedidos_pmp/src/admin/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/admin/domain/repositories/user_repository.dart';
import 'package:cpedidos_pmp/src/admin/domain/usecases/get_all_users.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late IUserRepository mockUserRepository;
  late GetAllUsersImpl usecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetAllUsersImpl(mockUserRepository);
  });

  const tUser = User(id: 'id', email: 'email', name: 'name', isAdmin: true);
  const tUserList = [tUser];

  test(
    'should return an user list on successfull get.',
    () async {
      // arrange
      when(() => mockUserRepository.getAllUsers())
          .thenAnswer((_) async => const Success(tUserList));
      // act
      final result = await usecase();
      // assert
      expect(result.getOrNull(), equals(tUserList));
    },
  );

  test(
    'should return a failure when user repository returns a failure.',
    () async {
      // arrange
      const tFailure = AdminFailure.unknownError;
      when(() => mockUserRepository.getAllUsers())
          .thenAnswer((_) async => const Failure(tFailure));
      // act
      final result = await usecase();
      // assert
      expect(result.exceptionOrNull(), equals(tFailure));
    },
  );
}

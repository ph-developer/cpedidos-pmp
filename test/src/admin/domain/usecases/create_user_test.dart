import 'package:cpedidos_pmp/src/admin/domain/entities/user.dart';
import 'package:cpedidos_pmp/src/admin/domain/repositories/user_repository.dart';
import 'package:cpedidos_pmp/src/admin/domain/usecases/create_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import 'package:cpedidos_pmp/src/admin/domain/errors/failures.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late IUserRepository mockUserRepository;
  late CreateUserImpl usecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = CreateUserImpl(mockUserRepository);
  });

  const tEmail = 'test@test.dev';
  const tPassword = 'password';
  const tName = 'name';
  const tIsAdmin = true;
  const tUser = User(id: 'id', email: tEmail, name: tName, isAdmin: tIsAdmin);

  test(
    'should return an user on successfull creation.',
    () async {
      // arrange
      when(() =>
              mockUserRepository.createUser(tEmail, tPassword, tName, tIsAdmin))
          .thenAnswer((_) async => const Success(tUser));
      // act
      final result = await usecase(tEmail, tPassword, tName, tIsAdmin);
      // assert
      expect(result.getOrNull(), equals(tUser));
    },
  );

  test(
    'should create an user with especified password when password is informed.',
    () async {
      // arrange
      when(() =>
              mockUserRepository.createUser(tEmail, tPassword, tName, tIsAdmin))
          .thenAnswer((_) async => const Success(tUser));
      // act
      await usecase(tEmail, tPassword, tName, tIsAdmin);
      // assert
      verify(() =>
              mockUserRepository.createUser(tEmail, tPassword, tName, tIsAdmin))
          .called(1);
    },
  );

  test(
    'should create an user with generated 12 digits password when password is not informed.',
    () async {
      // arrange
      when(() => mockUserRepository.createUser(tEmail, any(), tName, tIsAdmin))
          .thenAnswer((_) async => const Success(tUser));
      // act
      await usecase(tEmail, '', tName, tIsAdmin);
      final String capturedPassword = verify(() => mockUserRepository
          .createUser(tEmail, captureAny(), tName, tIsAdmin)).captured[0];
      // assert
      verifyNever(
          () => mockUserRepository.createUser(tEmail, '', tName, tIsAdmin));
      expect(capturedPassword.length, equals(12));
    },
  );

  test(
    'should return an emailCantBeEmpty failure when email is empty.',
    () async {
      // act
      final result = await usecase('', tPassword, tName, tIsAdmin);
      // assert
      expect(result.exceptionOrNull(), equals(AdminFailure.emailCantBeEmpty));
    },
  );

  test(
    'should return a nameCantBeEmpty failure when name is empty.',
    () async {
      // act
      final result = await usecase(tEmail, tPassword, '', tIsAdmin);
      // assert
      expect(result.exceptionOrNull(), equals(AdminFailure.nameCantBeEmpty));
    },
  );

  test(
    'should return an invalidEmail failure when email is invalid.',
    () async {
      // act
      final result = await usecase('invalid', tPassword, tName, tIsAdmin);
      // assert
      expect(result.exceptionOrNull(), equals(AdminFailure.invalidEmail));
    },
  );

  test(
    'should return a failure when user repository returns a failure.',
    () async {
      // arrange
      const tFailure = AdminFailure.unknownError;
      when(() =>
              mockUserRepository.createUser(tEmail, tPassword, tName, tIsAdmin))
          .thenAnswer((_) async => const Failure(tFailure));
      // act
      final result = await usecase(tEmail, tPassword, tName, tIsAdmin);
      // assert
      expect(result.exceptionOrNull(), equals(tFailure));
    },
  );
}

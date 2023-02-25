import 'package:cpedidos_pmp/src/admin/domain/entities/user.dart';
import 'package:cpedidos_pmp/src/admin/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/admin/infra/datasources/account_datasource.dart';
import 'package:cpedidos_pmp/src/admin/infra/datasources/profile_datasource.dart';
import 'package:cpedidos_pmp/src/admin/infra/repositories/user_repository_impl.dart';
import 'package:cpedidos_pmp/src/shared/services/error_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileDatasource extends Mock implements IProfileDatasource {}

class MockAccountDatasource extends Mock implements IAccountDatasource {}

class MockErrorService extends Mock implements IErrorService {}

void main() {
  late IProfileDatasource mockProfileDatasource;
  late IAccountDatasource mockAccountDatasource;
  late IErrorService mockErrorService;
  late UserRepositoryImpl repository;

  setUp(() {
    mockProfileDatasource = MockProfileDatasource();
    mockAccountDatasource = MockAccountDatasource();
    mockErrorService = MockErrorService();
    repository = UserRepositoryImpl(
      mockProfileDatasource,
      mockAccountDatasource,
      mockErrorService,
    );
  });

  const tId = 'id';
  const tEmail = 'test@test.dev';
  const tPassword = 'password';
  const tName = 'name';
  const tIsAdmin = true;
  const tUser = User(id: tId, email: tEmail, name: tName, isAdmin: tIsAdmin);
  const tUserList = [tUser];
  const tProfileMap = {
    'id': tId,
    'email': tEmail,
    'name': tName,
    'isAdmin': tIsAdmin
  };
  const tProfileMapList = [tProfileMap];

  group('createUser', () {
    test(
      'should return an user when create a user with success.',
      () async {
        // arrange
        when(() => mockAccountDatasource.createAccount(tEmail, tPassword))
            .thenAnswer((_) async => tId);
        when(() => mockProfileDatasource.createProfile(
            tId, tEmail, tName, tIsAdmin)).thenAnswer((_) async => tProfileMap);
        // act
        final result =
            await repository.createUser(tEmail, tPassword, tName, tIsAdmin);
        // assert
        expect(result.getOrNull(), equals(tUser));
      },
    );

    test(
      'should return a known failure when some datasource throws a known failure.',
      () async {
        // arrange
        const tFailure = AdminFailure.weakPassword;
        when(() => mockAccountDatasource.createAccount(tEmail, tPassword))
            .thenThrow(tFailure);
        // act
        final result =
            await repository.createUser(tEmail, tPassword, tName, tIsAdmin);
        // assert
        expect(result.exceptionOrNull(), equals(tFailure));
      },
    );

    test(
      'should report exception and return a failure when some unknown exception occurs.',
      () async {
        // arrange
        final tException = Exception('unknown');
        when(() => mockAccountDatasource.createAccount(tEmail, tPassword))
            .thenThrow(tException);
        when(() => mockErrorService.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result =
            await repository.createUser(tEmail, tPassword, tName, tIsAdmin);
        // assert
        verify(() => mockErrorService.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), equals(AdminFailure.unknownError));
      },
    );
  });

  group('deleteUser', () {
    test(
      'should return an user when create a user with success.',
      () async {
        // arrange
        when(() => mockAccountDatasource.deleteAccount(tId))
            .thenAnswer((_) async => true);
        when(() => mockProfileDatasource.deleteProfile(tId))
            .thenAnswer((_) async => true);
        // act
        final result = await repository.deleteUser(tId);
        // assert
        expect(result.getOrNull(), isTrue);
      },
    );

    test(
      'should return a known failure when some datasource throws a known failure.',
      () async {
        // arrange
        const tFailure = AdminFailure.weakPassword;
        when(() => mockAccountDatasource.deleteAccount(tId))
            .thenThrow(tFailure);
        // act
        final result = await repository.deleteUser(tId);
        // assert
        expect(result.exceptionOrNull(), equals(tFailure));
      },
    );

    test(
      'should report exception and return a failure when some unknown exception occurs.',
      () async {
        // arrange
        final tException = Exception('unknown');
        when(() => mockAccountDatasource.deleteAccount(tId))
            .thenThrow(tException);
        when(() => mockErrorService.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await repository.deleteUser(tId);
        // assert
        verify(() => mockErrorService.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), equals(AdminFailure.unknownError));
      },
    );
  });

  group('getAllUsers', () {
    test(
      'should return an user list when get with success.',
      () async {
        // arrange
        when(() => mockProfileDatasource.getAllProfiles())
            .thenAnswer((_) async => tProfileMapList);
        // act
        final result = await repository.getAllUsers();
        // assert
        expect(result.getOrNull(), equals(tUserList));
      },
    );

    test(
      'should return a known failure when some datasource throws a known failure.',
      () async {
        // arrange
        const tFailure = AdminFailure.weakPassword;
        when(() => mockProfileDatasource.getAllProfiles()).thenThrow(tFailure);
        // act
        final result = await repository.getAllUsers();
        // assert
        expect(result.exceptionOrNull(), equals(tFailure));
      },
    );

    test(
      'should report exception and return a failure when some unknown exception occurs.',
      () async {
        // arrange
        final tException = Exception('unknown');
        when(() => mockProfileDatasource.getAllProfiles())
            .thenThrow(tException);
        when(() => mockErrorService.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await repository.getAllUsers();
        // assert
        verify(() => mockErrorService.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), equals(AdminFailure.unknownError));
      },
    );
  });
}

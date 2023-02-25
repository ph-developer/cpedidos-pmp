import 'package:cpedidos_pmp/src/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repository.dart';
import 'package:cpedidos_pmp/src/auth/infra/datasources/auth_datasource.dart';
import 'package:cpedidos_pmp/src/shared/services/error_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthFailure extends Mock implements AuthFailure {}

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockAuthDatasource extends Mock implements IAuthDatasource {}

class MockErrorService extends Mock implements IErrorService {}

class MockFirebaseUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuthCredential extends Mock implements AuthCredential {}

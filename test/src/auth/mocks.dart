import 'package:bloc_test/bloc_test.dart';
import 'package:cpedidos_pmp/src/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repository.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_login.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_logout.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/get_current_user.dart';
import 'package:cpedidos_pmp/src/auth/infra/datasources/auth_datasource.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_cubit.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_state.dart';
import 'package:cpedidos_pmp/src/shared/services/error_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthFailure extends Mock implements AuthFailure {}

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockAuthDatasource extends Mock implements IAuthDatasource {}

class MockErrorService extends Mock implements IErrorService {}

class MockFirebaseUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockGetCurrentUser extends Mock implements IGetCurrentUser {}

class MockDoLogin extends Mock implements IDoLogin {}

class MockDoLogout extends Mock implements IDoLogout {}

class MockModularRoute extends Mock implements ModularRoute {}

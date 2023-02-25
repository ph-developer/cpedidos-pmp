import 'package:result_dart/result_dart.dart';

import '../../../shared/services/error_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/errors/failures.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/account_datasource.dart';
import '../datasources/profile_datasource.dart';
import '../dtos/user_dto.dart';

class UserRepositoryImpl implements IUserRepository {
  final IProfileDatasource _profileDatasource;
  final IAccountDatasource _accountDatasource;
  final IErrorService _errorService;

  UserRepositoryImpl(
    this._profileDatasource,
    this._accountDatasource,
    this._errorService,
  );

  @override
  AsyncResult<User, AdminFailure> createUser(
      String email, String password, String name, bool isAdmin) async {
    try {
      final userId = await _accountDatasource.createAccount(email, password);
      await _profileDatasource.createProfile(userId, name, isAdmin);
      final userMap = {
        'id': userId,
        'email': email,
        'name': name,
        'isAdmin': isAdmin,
      };
      final user = UserDTO.fromMap(userMap);

      return Success(user);
    } on AdminFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorService.reportException(exception, stackTrace);
      return const Failure(AdminFailure.unknownError);
    }
  }

  @override
  AsyncResult<bool, AdminFailure> deleteUser(String id) async {
    try {
      await _accountDatasource.deleteAccount(id);
      await _profileDatasource.deleteProfile(id);

      return const Success(true);
    } on AdminFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorService.reportException(exception, stackTrace);
      return const Failure(AdminFailure.unknownError);
    }
  }
}

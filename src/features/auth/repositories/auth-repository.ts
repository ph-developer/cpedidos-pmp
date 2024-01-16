import { User } from 'src/features/auth/types/user';
import {
  AuthRepositoryValidatorDecorator,
} from 'src/features/auth/repositories/decorators/auth-repository-validator-decorator';
import { AuthRepositoryImpl } from 'src/features/auth/repositories/auth-repository-impl';

export interface AuthRepository {
  /**
   * Retrieve current authenticated user or throws a failure.
   *
   * @throws UserUnauthenticated
   */
  getCurrentUser: () => Promise<User>;

  /**
   * Try to authenticate user credentials.
   *
   * @param email
   * @param password
   * @throws InvalidCredentials
   */
  doLogin: (email: string, password: string) => Promise<User>;

  /**
   * Try logout.
   */
  doLogout: () => Promise<void>;
}

export const useAuthRepository = (): AuthRepository => AuthRepositoryValidatorDecorator(
  AuthRepositoryImpl(),
);

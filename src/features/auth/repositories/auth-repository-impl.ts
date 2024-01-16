import { AuthRepository } from 'src/features/auth/repositories/auth-repository';
import { User } from 'src/features/auth/types/user';
import { getAuth, signInWithEmailAndPassword, signOut } from 'firebase/auth';
import { InvalidCredentials, UserUnauthenticated } from 'src/features/auth/errors/auth-failures';
import { FirebaseError } from '@firebase/util';
import { userMapper } from 'src/features/auth/repositories/mappers/user-mapper';

export const AuthRepositoryImpl = (): AuthRepository => ({
  /**
   * Retrieve current authenticated user or throws a failure.
   *
   * @throws UserUnauthenticated
   */
  async getCurrentUser(): Promise<User> {
    const auth = getAuth();
    const firebaseUser = auth.currentUser;

    if (firebaseUser === null) {
      // TODO: remove if unnecessary
      // firebaseUser ??= await _firebaseAuth.authStateChanges().first;
    }

    if (firebaseUser === null) {
      throw new UserUnauthenticated();
    }

    return userMapper.fromFirebaseUser(firebaseUser);
  },

  /**
   * Try to authenticate user credentials.
   *
   * @param email
   * @param password
   * @throws InvalidCredentials
   */
  async doLogin(email: string, password: string): Promise<User> {
    const auth = getAuth();

    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const firebaseUser = userCredential.user;

      return userMapper.fromFirebaseUser(firebaseUser);
    } catch (e) {
      if (e instanceof FirebaseError) {
        throw new InvalidCredentials();
      } else {
        throw e;
      }
    }
  },

  /**
   * Try logout.
   */
  async doLogout(): Promise<void> {
    const auth = getAuth();
    await signOut(auth);
  },
});

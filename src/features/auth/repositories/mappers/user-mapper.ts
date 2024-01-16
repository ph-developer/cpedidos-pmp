import { User as FirebaseUser } from 'firebase/auth';
import { User } from 'src/features/auth/types/user';

export const userMapper = {
  fromFirebaseUser(firebaseUser: FirebaseUser): User {
    return {
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
    };
  },
};

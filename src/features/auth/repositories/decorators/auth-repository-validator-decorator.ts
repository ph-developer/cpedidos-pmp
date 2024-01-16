import { AuthRepository } from 'src/features/auth/repositories/auth-repository';
import { User } from 'src/features/auth/types/user';
import { InvalidInput } from 'src/features/orders/errors/order-failures';
import { EmailValidator } from 'src/features/shared/utils/email-validator';

export const AuthRepositoryValidatorDecorator = (
  decorated: AuthRepository,
): AuthRepository => ({
  ...decorated,

  /**
   * Validate arguments and return decorated method.
   *
   * @param email
   * @param password
   * @throws InvalidInput
   */
  async doLogin(email: string, password: string): Promise<User> {
    if (email === '') {
      throw new InvalidInput('O campo "email" deve ser preenchido.');
    }
    if (password === '') {
      throw new InvalidInput('O campo "senha" deve ser preenchido.');
    }
    if (!EmailValidator.validate(email)) {
      throw new InvalidInput('O email informado possui um formato inválido.');
    }
    return decorated.doLogin(email, password);
  },
});

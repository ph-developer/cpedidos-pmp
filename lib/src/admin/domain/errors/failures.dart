enum AdminFailure {
  emailAlreadyInUse('O email informado já está em uso.'),
  invalidEmail('O email informado possui um formato inválido.'),
  idCantBeEmpty('O campo id é obrigatório.'),
  nameCantBeEmpty('O campo nome é obrigatório.'),
  emailCantBeEmpty('O campo email é obrigatório.'),
  operationNotAllowed('Operação não permitida.'),
  weakPassword('A senha informada é muito fraca.'),
  unknownError('Ocorreu um erro desconhecido.');

  final String message;

  const AdminFailure(this.message);
}

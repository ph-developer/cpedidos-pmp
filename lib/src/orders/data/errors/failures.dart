import '../../../shared/errors/failure.dart';

class GetByTypeAndNumberFailure extends Failure {
  GetByTypeAndNumberFailure([
    String message = 'Ocorreu um erro ao buscar o pedido.',
  ]) : super(message);
}

class GetAllBySendDateFailure extends Failure {
  GetAllBySendDateFailure([
    String message = 'Ocorreu um erro ao buscar os pedidos.',
  ]) : super(message);
}

class SaveFailure extends Failure {
  SaveFailure([
    String message = 'Ocorreu um erro ao salvar o pedido.',
  ]) : super(message);
}

class DeleteFailure extends Failure {
  DeleteFailure([
    String message = 'Ocorreu um erro ao excluir o pedido.',
  ]) : super(message);
}

abstract class OrdersFailure implements Exception {
  final String message;
  const OrdersFailure(this.message);
}

class InvalidInput extends OrdersFailure {
  const InvalidInput(super.message);
}

class OrderNotFound extends OrdersFailure {
  const OrderNotFound() : super('Pedido não encontrado.');
}

class OrdersNotFound extends OrdersFailure {
  const OrdersNotFound() : super('Nenhum pedido encontrado.');
}

class UnknownError extends OrdersFailure {
  const UnknownError() : super('Ocorreu um erro desconhecido.');
}

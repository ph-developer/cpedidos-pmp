abstract class OrdersFailure implements Exception {
  final String message;
  OrdersFailure(this.message);
}

class InvalidInput extends OrdersFailure {
  InvalidInput(super.message);
}

class OrderNotFound extends OrdersFailure {
  OrderNotFound() : super('Pedido não encontrado.');
}

class OrdersNotFound extends OrdersFailure {
  OrdersNotFound() : super('Nenhum pedido encontrado.');
}

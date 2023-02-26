import 'package:result_dart/result_dart.dart';

import '../errors/failures.dart';
import '../repositories/order_repository.dart';

abstract class IDeleteOrder {
  AsyncResult<Unit, OrdersFailure> call(String type, String number);
}

class DeleteOrder implements IDeleteOrder {
  final IOrderRepository _orderRepository;

  DeleteOrder(this._orderRepository);

  @override
  AsyncResult<Unit, OrdersFailure> call(String type, String number) async {
    if (number.isEmpty) {
      return const Failure(
        InvalidInput('O campo "número" deve ser preenchido.'),
      );
    }

    if (type.isEmpty) {
      return const Failure(
        InvalidInput('O campo "tipo" deve ser preenchido.'),
      );
    }

    return _orderRepository.deleteOrder(type, number);
  }
}

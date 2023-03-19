import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';
import '../repositories/order_repository.dart';

abstract class IDeleteOrder {
  AsyncResult<Unit, OrdersFailure> call(Order order);
}

class DeleteOrderImpl implements IDeleteOrder {
  final IOrderRepository _orderRepository;

  DeleteOrderImpl(this._orderRepository);

  @override
  AsyncResult<Unit, OrdersFailure> call(Order order) async {
    if (order.isArchived) {
      return const Failure(
        InvalidInput(
          'Este pedido está arquivado e não pode receber alterações.',
        ),
      );
    }

    if (order.number.isEmpty) {
      return const Failure(
        InvalidInput('O campo "número" deve ser preenchido.'),
      );
    }

    if (order.type.isEmpty) {
      return const Failure(
        InvalidInput('O campo "tipo" deve ser preenchido.'),
      );
    }

    return _orderRepository.deleteOrder(order);
  }
}

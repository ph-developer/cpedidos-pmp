import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';
import '../repositories/order_repo.dart';

abstract class IDeleteOrder {
  AsyncResult<bool, OrdersFailure> call(Order order);
}

class DeleteOrder implements IDeleteOrder {
  final IOrderRepo _orderRepo;

  DeleteOrder(this._orderRepo);

  @override
  AsyncResult<bool, OrdersFailure> call(Order order) async {
    if (order.number.isEmpty) {
      return Failure(InvalidInput('O campo "número" deve ser preenchido.'));
    }

    if (order.type.isEmpty) {
      return Failure(InvalidInput('O campo "tipo" deve ser preenchido.'));
    }

    return _orderRepo.delete(order);
  }
}

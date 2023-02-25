import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';
import '../repositories/order_repo.dart';

abstract class ISaveOrder {
  AsyncResult<Order, OrdersFailure> call(Order order);
}

class SaveOrder implements ISaveOrder {
  final IOrderRepo _orderRepo;

  SaveOrder(this._orderRepo);

  @override
  AsyncResult<Order, OrdersFailure> call(Order order) async {
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

    if (order.arrivalDate.isEmpty) {
      return const Failure(
        InvalidInput('O campo "data de chegada" deve ser preenchido.'),
      );
    }

    if (order.secretary.isEmpty) {
      return const Failure(
        InvalidInput('O campo "secretaria" deve ser preenchido.'),
      );
    }

    if (order.project.isEmpty) {
      return const Failure(
        InvalidInput('O campo "projeto" deve ser preenchido.'),
      );
    }

    if (order.description.isEmpty) {
      return const Failure(
        InvalidInput('O campo "descrição" deve ser preenchido.'),
      );
    }

    return _orderRepo.save(order);
  }
}

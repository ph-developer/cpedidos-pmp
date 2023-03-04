import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';
import '../repositories/order_repository.dart';

abstract class IGetAllOrdersByArrivalDate {
  AsyncResult<List<Order>, OrdersFailure> call(String arrivalDate);
}

class GetAllOrdersByArrivalDate implements IGetAllOrdersByArrivalDate {
  final IOrderRepository _orderRepository;

  GetAllOrdersByArrivalDate(this._orderRepository);

  @override
  AsyncResult<List<Order>, OrdersFailure> call(String arrivalDate) async {
    if (arrivalDate.isEmpty) {
      return const Failure(
        InvalidInput('O campo "data de chegada" deve ser preenchido.'),
      );
    }

    return _orderRepository.getAllOrdersByArrivalDate(arrivalDate);
  }
}

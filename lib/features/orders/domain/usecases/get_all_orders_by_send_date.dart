import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';
import '../repositories/order_repository.dart';

abstract class IGetAllOrdersBySendDate {
  AsyncResult<List<Order>, OrdersFailure> call(String sendDate);
}

class GetAllOrdersBySendDateImpl implements IGetAllOrdersBySendDate {
  final IOrderRepository _orderRepository;

  GetAllOrdersBySendDateImpl(this._orderRepository);

  @override
  AsyncResult<List<Order>, OrdersFailure> call(String sendDate) async {
    if (sendDate.isEmpty) {
      return const Failure(
        InvalidInput('O campo "data de envio" deve ser preenchido.'),
      );
    }

    return _orderRepository.getAllOrdersBySendDate(sendDate);
  }
}

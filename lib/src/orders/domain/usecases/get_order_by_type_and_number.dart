import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';
import '../repositories/order_repo.dart';

abstract class IGetOrderByTypeAndNumber {
  AsyncResult<Order, OrdersFailure> call(String type, String number);
}

class GetOrderByTypeAndNumber implements IGetOrderByTypeAndNumber {
  final IOrderRepo _orderRepo;

  GetOrderByTypeAndNumber(this._orderRepo);

  @override
  AsyncResult<Order, OrdersFailure> call(String type, String number) async {
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

    return _orderRepo.getByTypeAndNumber(type, number);
  }
}

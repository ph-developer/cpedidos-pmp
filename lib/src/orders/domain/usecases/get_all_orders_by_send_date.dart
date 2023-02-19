import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';
import '../repositories/order_repo.dart';

abstract class IGetAllOrdersBySendDate {
  AsyncResult<List<Order>, OrdersFailure> call(String sendDate);
}

class GetAllOrdersBySendDate implements IGetAllOrdersBySendDate {
  final IOrderRepo _orderRepo;

  GetAllOrdersBySendDate(this._orderRepo);

  @override
  AsyncResult<List<Order>, OrdersFailure> call(String sendDate) async {
    if (sendDate.isEmpty) {
      return Failure(
        InvalidInput('O campo "data de envio" deve ser preenchido.'),
      );
    }

    return _orderRepo.getAllBySendDate(sendDate);
  }
}

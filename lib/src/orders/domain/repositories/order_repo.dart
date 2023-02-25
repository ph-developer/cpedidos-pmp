import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';

abstract class IOrderRepo {
  AsyncResult<Order, OrdersFailure> getByTypeAndNumber(
    String type,
    String number,
  );
  AsyncResult<List<Order>, OrdersFailure> getAllBySendDate(String sendDate);
  AsyncResult<Order, OrdersFailure> save(Order order);
  AsyncResult<bool, OrdersFailure> delete(Order order);
}

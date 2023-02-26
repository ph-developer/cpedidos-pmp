import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';

abstract class IOrderRepository {
  AsyncResult<Order, OrdersFailure> getOrderByTypeAndNumber(
    String type,
    String number,
  );
  AsyncResult<List<Order>, OrdersFailure> getAllOrdersBySendDate(
    String sendDate,
  );
  AsyncResult<Order, OrdersFailure> saveOrder(Order order);
  AsyncResult<Unit, OrdersFailure> deleteOrder(String type, String number);
}

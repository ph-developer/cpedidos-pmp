import 'package:firebase_database/firebase_database.dart';
import 'package:result_dart/result_dart.dart';

import '../../../domain/entities/order.dart';
import '../../../domain/errors/failures.dart';
import '../../../domain/repositories/order_repo.dart';
import '../../dtos/order_dto.dart';

class FirebaseOrderRemoteRepo implements IOrderRepo {
  final FirebaseDatabase _database;

  FirebaseOrderRemoteRepo(this._database);

  @override
  AsyncResult<Order, OrdersFailure> getByTypeAndNumber(
      String type, String number) async {
    final orderRef = _database.ref('orders/${type}_$number');
    final orderSnapshot = await orderRef.get();

    if (!orderSnapshot.exists) {
      return const Failure(OrderNotFound());
    }

    final orderMap = orderSnapshot.value as Map<String, dynamic>;
    final order = OrderDTO.fromMap(orderMap);

    return Success(order);
  }

  @override
  AsyncResult<List<Order>, OrdersFailure> getAllBySendDate(
      String sendDate) async {
    final ordersSnapshot = await _database
        .ref('orders')
        .orderByChild('sendDate')
        .equalTo(sendDate)
        .get();

    if (!ordersSnapshot.exists) {
      return const Failure(OrdersNotFound());
    }

    final ordersMap = ordersSnapshot.value as Map<String, dynamic>;
    final orders =
        ordersMap.values.map((orderMap) => OrderDTO.fromMap(orderMap)).toList();

    return Success(orders);
  }

  @override
  AsyncResult<Order, OrdersFailure> save(Order order) async {
    final orderRef = _database.ref('orders/${order.id}');

    await orderRef.set(order.toMap());

    return Success(order);
  }

  @override
  AsyncResult<bool, OrdersFailure> delete(Order order) async {
    final orderRef = _database.ref('orders/${order.id}');

    await orderRef.remove();

    return const Success(true);
  }
}

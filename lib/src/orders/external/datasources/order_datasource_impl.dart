import 'package:firebase_database/firebase_database.dart';

import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';
import '../../infra/datasources/order_datasource.dart';
import '../dtos/order_dto.dart';

class OrderDatasourceImpl implements IOrderDatasource {
  final FirebaseDatabase _firebaseDatabase;

  OrderDatasourceImpl(this._firebaseDatabase);

  @override
  Future<Order> getOrderByTypeAndNumber(String type, String number) async {
    final orderId = '${type}_$number';
    final orderRef = _firebaseDatabase.ref('orders/$orderId');
    final orderSnapshot = await orderRef.get();

    if (!orderSnapshot.exists) {
      throw const OrderNotFound();
    }

    final orderMap = orderSnapshot.value! as Map<String, dynamic>;
    final order = OrderDTO.fromMap(orderMap);

    return order;
  }

  @override
  Future<List<Order>> getAllOrdersBySendDate(String sendDate) async {
    final ordersSnapshot = await _firebaseDatabase
        .ref('orders')
        .orderByChild('sendDate')
        .equalTo(sendDate)
        .get();

    if (!ordersSnapshot.exists) {
      throw const OrdersNotFound();
    }

    final ordersMap = ordersSnapshot.value! as Map<String, dynamic>;
    final ordersMapList = List<Map<String, dynamic>>.from(ordersMap.values);
    final orders = ordersMapList.map(OrderDTO.fromMap).toList();

    return orders;
  }

  @override
  Future<Order> saveOrder(Order order) async {
    final orderId = '${order.type}_${order.number}';
    final orderRef = _firebaseDatabase.ref('orders/$orderId');

    await orderRef.set(order.toMap());

    return order;
  }

  @override
  Future<bool> deleteOrder(String type, String number) async {
    final orderId = '${type}_$number';
    final orderRef = _firebaseDatabase.ref('orders/$orderId');

    await orderRef.remove();

    return true;
  }
}

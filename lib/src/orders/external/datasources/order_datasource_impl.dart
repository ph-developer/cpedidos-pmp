import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';
import '../../infra/datasources/order_datasource.dart';
import '../dtos/order_dto.dart';

class OrderDatasourceImpl implements IOrderDatasource {
  final FirebaseFirestore _firebaseFirestore;

  OrderDatasourceImpl(this._firebaseFirestore);

  @override
  Future<Order> getOrderByTypeAndNumber(String type, String number) async {
    final orderId = '${type}_$number';
    final ordersCollection = _firebaseFirestore.collection('orders');
    final orderDoc = ordersCollection.doc(orderId);
    final orderSnapshot = await orderDoc.get();

    if (!orderSnapshot.exists) {
      throw const OrderNotFound();
    }

    final orderMap = orderSnapshot.data()!;
    final order = OrderDTO.fromMap(orderMap);

    return order;
  }

  @override
  Future<List<Order>> getAllOrdersBySendDate(String sendDate) async {
    final ordersCollection = _firebaseFirestore.collection('orders');
    final query = ordersCollection.where('sendDate', isEqualTo: sendDate);
    final ordersSnapshot = await query.get();

    if (ordersSnapshot.docs.isEmpty) {
      throw const OrdersNotFound();
    }

    final ordersMap = ordersSnapshot.docs;
    final orders = ordersMap
        .map((orderSnapshot) => orderSnapshot.data())
        .map(OrderDTO.fromMap)
        .toList();

    return orders;
  }

  @override
  Future<List<Order>> getAllOrdersByArrivalDate(String arrivalDate) async {
    final ordersCollection = _firebaseFirestore.collection('orders');
    final query = ordersCollection.where('arrivalDate', isEqualTo: arrivalDate);
    final ordersSnapshot = await query.get();

    if (ordersSnapshot.docs.isEmpty) {
      throw const OrdersNotFound();
    }

    final ordersMap = ordersSnapshot.docs;
    final orders = ordersMap
        .map((orderSnapshot) => orderSnapshot.data())
        .map(OrderDTO.fromMap)
        .toList();

    return orders;
  }

  @override
  Future<Order> saveOrder(Order order) async {
    final orderId = '${order.type}_${order.number}';
    final ordersCollection = _firebaseFirestore.collection('orders');
    final orderDoc = ordersCollection.doc(orderId);

    await orderDoc.set(order.toMap());

    return order;
  }

  @override
  Future<bool> deleteOrder(String type, String number) async {
    final orderId = '${type}_$number';
    final ordersCollection = _firebaseFirestore.collection('orders');
    final orderDoc = ordersCollection.doc(orderId);

    await orderDoc.delete();

    return true;
  }
}

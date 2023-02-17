import 'package:firebase_database/firebase_database.dart';

import '../../../domain/entities/order.dart';
import '../../../domain/repositories/order_repo.dart';
import '../../dtos/order_dto.dart';
import '../../errors/failures.dart';

class FirebaseOrderRemoteRepo implements IOrderRepo {
  final FirebaseDatabase _database;

  FirebaseOrderRemoteRepo(this._database);

  @override
  Future<Order?> getByTypeAndNumber(String type, String number) async {
    try {
      final orderRef = _database.ref('orders/${type}_$number');
      final orderSnapshot = await orderRef.get();

      if (!orderSnapshot.exists) return null;

      final orderMap = orderSnapshot.value as Map<String, dynamic>;

      return OrderDTO.fromMap(orderMap);
    } catch (e) {
      throw GetByTypeAndNumberFailure();
    }
  }

  @override
  Future<List<Order>> getAllBySendDate(String sendDate) async {
    try {
      final ordersSnapshot = await _database
          .ref('orders')
          .orderByChild('sendDate')
          .equalTo(sendDate)
          .get();

      if (!ordersSnapshot.exists) return [];

      final orders = ordersSnapshot.value as Map<String, dynamic>;

      return orders.values
          .map((orderMap) => OrderDTO.fromMap(orderMap))
          .toList();
    } catch (e) {
      throw GetAllBySendDateFailure();
    }
  }

  @override
  Future<Order?> save(Order order) async {
    try {
      final orderRef = _database.ref('orders/${order.id}');

      await orderRef.set(order.toMap());

      return order;
    } catch (e) {
      throw SaveFailure();
    }
  }

  @override
  Future<bool> delete(Order order) async {
    try {
      final orderRef = _database.ref('orders/${order.id}');

      await orderRef.remove();

      return true;
    } catch (e) {
      throw DeleteFailure();
    }
  }
}

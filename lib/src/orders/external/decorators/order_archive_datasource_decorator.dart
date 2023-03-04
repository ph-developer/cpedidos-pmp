import 'package:firebase_database/firebase_database.dart';

import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';
import '../dtos/order_dto.dart';
import 'order_datasource_decorator.dart';

class OrderArchiveDatasourceDecorator extends OrderDatasourceDecorator {
  final FirebaseDatabase _firebaseDatabase;

  OrderArchiveDatasourceDecorator(
    super._decoratee,
    this._firebaseDatabase,
  );

  @override
  Future<Order> getOrderByTypeAndNumber(String type, String number) async {
    try {
      final order = await super.getOrderByTypeAndNumber(type, number);

      return order;
    } on OrderNotFound {
      final currentYear = DateTime.now().year;

      for (var i = 2021; i < currentYear; i++) {
        final year = i.toString();
        final orderId = '${type}_$number';
        final order = await _getArchivedOrderByTypeAndNumber(orderId, year);

        if (order != null) return order;
      }

      rethrow;
    }
  }

  Future<Order?> _getArchivedOrderByTypeAndNumber(
    String orderId,
    String year,
  ) async {
    final orderRef = _firebaseDatabase.ref('archive/orders/$year/$orderId');
    final orderSnapshot = await orderRef.get();

    if (!orderSnapshot.exists) return null;

    final orderMap = orderSnapshot.value! as Map<String, dynamic>;
    orderMap['isArchived'] = true;
    final order = OrderDTO.fromMap(orderMap);

    return order;
  }
}

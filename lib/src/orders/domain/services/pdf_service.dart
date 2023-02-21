import 'dart:typed_data';

import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';

abstract class IPdfService {
  AsyncResult<Uint8List, OrdersFailure> generateOrdersReport(
      List<Order> orders);
}

import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';

abstract class IReportService {
  AsyncResult<Unit, OrdersFailure> printOrdersReport(List<Order> orders);
}

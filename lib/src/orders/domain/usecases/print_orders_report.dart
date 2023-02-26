import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';
import '../services/report_service.dart';

abstract class IPrintOrdersReport {
  AsyncResult<Unit, OrdersFailure> call(List<Order> orders);
}

class PrintOrdersReport implements IPrintOrdersReport {
  final IReportService _reportService;

  PrintOrdersReport(this._reportService);

  @override
  AsyncResult<Unit, OrdersFailure> call(List<Order> orders) async {
    if (orders.isEmpty) {
      return const Failure(
        InvalidInput('Nenhum pedido foi carregado.'),
      );
    }

    return _reportService.printOrdersReport(orders);
  }
}

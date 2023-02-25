import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';
import '../services/pdf_service.dart';
import '../services/print_service.dart';

abstract class IPrintOrdersReport {
  AsyncResult<Unit, OrdersFailure> call(List<Order> orders);
}

class PrintOrdersReport implements IPrintOrdersReport {
  final IPdfService _pdfService;
  final IPrintService _printService;

  PrintOrdersReport(this._pdfService, this._printService);

  @override
  AsyncResult<Unit, OrdersFailure> call(List<Order> orders) async {
    if (orders.isEmpty) {
      return const Failure(
        InvalidInput('Nenhum pedido foi carregado.'),
      );
    }

    return _pdfService
        .generateOrdersReport(orders)
        .flatMap(_printService.printPdfBytes);
  }
}

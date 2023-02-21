import 'dart:typed_data';

import 'package:printing/printing.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/errors/failures.dart';
import '../../domain/services/print_service.dart';

class PrintService implements IPrintService {
  @override
  AsyncResult<Unit, OrdersFailure> printPdfBytes(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (_) => bytes);

    return const Success(unit);
  }
}

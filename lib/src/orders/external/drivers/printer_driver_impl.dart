import 'dart:typed_data';

import 'package:printing/printing.dart';

import '../../infra/drivers/printer_driver.dart';

class PrinterDriverImpl implements IPrinterDriver {
  @override
  Future<bool> printPdfBytes(Uint8List pdfBytes) async {
    await Printing.layoutPdf(onLayout: (_) => pdfBytes);

    return true;
  }
}

import 'dart:typed_data';

abstract class IPrinterDriver {
  Future<bool> printPdfBytes(Uint8List pdfBytes);
}

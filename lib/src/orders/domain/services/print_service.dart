import 'dart:typed_data';

import 'package:result_dart/result_dart.dart';

import '../errors/failures.dart';

abstract class IPrintService {
  AsyncResult<Unit, OrdersFailure> printPdfBytes(Uint8List bytes);
}

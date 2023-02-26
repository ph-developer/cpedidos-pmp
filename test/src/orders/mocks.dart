import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repository.dart';
import 'package:cpedidos_pmp/src/orders/domain/services/report_service.dart';
import 'package:cpedidos_pmp/src/orders/infra/datasources/order_datasource.dart';
import 'package:cpedidos_pmp/src/orders/infra/drivers/printer_driver.dart';
import 'package:cpedidos_pmp/src/shared/services/error_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdf/pdf.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:printing/src/callback.dart';
import 'package:printing/src/interface.dart';
import 'package:printing/src/printer.dart';

class MockOrdersFailure extends Mock implements OrdersFailure {}

class MockOrderRepository extends Mock implements IOrderRepository {}

class MockOrderDatasource extends Mock implements IOrderDatasource {}

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

class MockErrorService extends Mock implements IErrorService {}

class MockReportService extends Mock implements IReportService {}

class MockPrinterDriver extends Mock implements IPrinterDriver {}

class MockPrintingPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PrintingPlatform {
  @override
  Future<bool> layoutPdf(
    Printer? printer,
    LayoutCallback onLayout,
    String name,
    PdfPageFormat format,
    bool dynamicLayout,
    bool usePrinterSettings,
  ) async {
    return true;
  }
}

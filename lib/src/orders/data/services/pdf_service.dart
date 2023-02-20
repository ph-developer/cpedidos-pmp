import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';
import '../../domain/services/pdf_service.dart';

class PdfService implements IPdfService {
  @override
  AsyncResult<Uint8List, OrdersFailure> generateOrdersReport(
      List<Order> orders) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18.0, vertical: 26.0),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'Listagem de Pedidos para Envio',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  pw.SizedBox(height: 6.0),
                  pw.Text(
                    'Data de Envio: ${orders.first.sendDate}',
                    style: const pw.TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                  pw.SizedBox(height: 12.0),
                ],
              ),
            ],
          ),
          pw.Table.fromTextArray(
            context: context,
            headerAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
            },
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerLeft,
            },
            columnWidths: {
              0: const pw.FixedColumnWidth(50.0),
              1: const pw.FlexColumnWidth(3.0),
              2: const pw.FlexColumnWidth(2.0),
              3: const pw.FlexColumnWidth(10.0),
            },
            headers: ['#', 'Secretaria', 'Projeto', 'Descrição'],
            data: [
              ...orders.map(
                (order) => [
                  '${order.type}\n${order.number}',
                  order.secretary,
                  order.project,
                  order.description,
                ],
              ),
            ],
          ),
        ],
      ),
    );

    final pdfBytes = await pdf.save();

    return Success(pdfBytes);
  }
}

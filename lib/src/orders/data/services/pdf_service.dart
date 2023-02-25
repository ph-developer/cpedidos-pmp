import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';
import '../../domain/services/pdf_service.dart';

class PdfService implements IPdfService {
  @override
  AsyncResult<Uint8List, OrdersFailure> generateOrdersReport(
    List<Order> orders,
  ) async {
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(
          await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'),
        ),
        bold: pw.Font.ttf(
          await rootBundle.load('assets/fonts/OpenSans-Bold.ttf'),
        ),
        italic: pw.Font.ttf(
          await rootBundle.load('assets/fonts/OpenSans-Italic.ttf'),
        ),
        boldItalic: pw.Font.ttf(
          await rootBundle.load('assets/fonts/OpenSans-BoldItalic.ttf'),
        ),
      ),
    )..addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 26),
          build: (context) => [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Column(
                  children: [
                    pw.Text(
                      'Listagem de Pedidos para Envio',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'Data de Envio: ${orders.first.sendDate}',
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    pw.SizedBox(height: 12),
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
                0: const pw.FixedColumnWidth(50),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(3),
                3: const pw.FlexColumnWidth(9),
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

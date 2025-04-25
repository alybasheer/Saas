import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'dart:io';
import '../models/payment.dart';

class ReceiptService {
  static Future<File> generateReceipt(Payment payment) async {
    final pdf = pw.Document();

    final logo = await rootBundle.load('assets/logo.png');
    final image = pw.MemoryImage(logo.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Image(image, width: 100),
            pw.SizedBox(height: 20),
            pw.Text('Payment Receipt', style: pw.TextStyle(fontSize: 24)),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Receipt No:'),
                pw.Text(payment.id),
              ],
            ),
            // Add more payment details
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/receipt_${payment.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
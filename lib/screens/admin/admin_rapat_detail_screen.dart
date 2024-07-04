import 'package:flutter/material.dart';
import 'package:apprapat/models/rapat.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminRapatDetailScreen extends StatelessWidget {
  final Rapat rapat;

  AdminRapatDetailScreen({required this.rapat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Rapat Admin'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              _generatePdf(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Agenda: ${rapat.agenda}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Tanggal: ${rapat.tanggal}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Jam: ${rapat.jam}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Lokasi: ${rapat.lokasi}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Kategori: ${rapat.kategori}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      if (rapat.hasil != null)
                        Text('Hasil: ${rapat.hasil}', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Detail Rapat', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Agenda: ${rapat.agenda}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 8),
              pw.Text('Tanggal: ${rapat.tanggal}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 8),
              pw.Text('Jam: ${rapat.jam}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 8),
              pw.Text('Lokasi: ${rapat.lokasi}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 8),
              pw.Text('Kategori: ${rapat.kategori}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 8),
              if (rapat.hasil != null)
                pw.Text('Hasil: ${rapat.hasil}', style: pw.TextStyle(fontSize: 18)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HalamanDetailPesanan extends StatelessWidget {
  final String cabang;
  final String metode;
  final String tanggal;
  final String jam;

  const HalamanDetailPesanan({
    super.key,
    required this.cabang,
    required this.metode,
    required this.tanggal,
    required this.jam,
  });

  // Fungsi Cetak PDF (Hanya berjalan jika tombol PDF ditekan customer)
  Future<void> _prosesCetakPdf(BuildContext context) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // Ukuran kertas struk thermal kasir
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(child: pw.Text("SWEET BAKERY", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14))),
                pw.Center(child: pw.Text("Nota Transaksi Digital")),
                pw.SizedBox(height: 5),
                pw.Divider(borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 5),
                pw.Text("Cabang   : $cabang"),
                pw.Text("Metode   : $metode"),
                pw.Text("Tanggal  : $tanggal"),
                pw.Text("Jam      : $jam"),
                pw.SizedBox(height: 5),
                pw.Divider(borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [pw.Text("Total Bayar"), pw.Text("Rp 35.000")],
                ),
                pw.SizedBox(height: 10),
                pw.Center(child: pw.Text("~ Terima Kasih ~", style: pw.TextStyle(fontSize: 8))),
              ],
            ),
          );
        },
      ),
    );

    // Buka pratinjau cetak sistem
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text("Detail Nota Belanja"),
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Tampilan preview Nota Transaksi di Layar Aplikasi
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "SWEET BAKERY",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF6F4E37)),
                      ),
                    ),
                    const Center(child: Text("Rincian Transaksi Anda", style: TextStyle(color: Colors.grey))),
                    const Divider(height: 30, thickness: 1.5),
                    
                    _buildRowDetail("Lokasi Cabang", cabang),
                    _buildRowDetail("Metode Kirim", metode),
                    _buildRowDetail("Tanggal Ambil", tanggal),
                    _buildRowDetail("Jam Ambil", jam),
                    
                    const Divider(height: 30, thickness: 1.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Total Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Rp 35.000", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // PILIHAN 1: Cetak ke PDF (Opsional bagi Customer)
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text("Cetak Dokumen PDF", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () => _prosesCetakPdf(context),
              ),
            ),
            const SizedBox(height: 10),

            // PILIHAN 2: Selesai (Kembali ke halaman utama order list tanpa cetak apa-apa)
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF6F4E37))),
                onPressed: () {
                  // Membersihkan tumpukan halaman dan kembali ke screen PesananPage paling depan
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Selesai & Kembali", style: TextStyle(color: Color(0xFF6F4E37), fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
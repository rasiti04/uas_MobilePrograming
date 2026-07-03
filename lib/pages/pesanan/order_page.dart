import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_uts/models/pesanan.dart';
import 'package:project_uts/models/produk.dart';
import 'package:project_uts/pages/pesanan/pesanan_page.dart';
import 'package:project_uts/services/api_service.dart';

/// Halaman order untuk 1 produk yang dipilih dari Etalase Kue.
/// Setelah tombol ORDER ditekan:
///  1. Kirim pesanan baru ke REST API (POST /api/pesanan)
///  2. Tampilkan notifikasi "Pesanan berhasil"
///  3. Pindah ke halaman Daftar Pesanan
class OrderPage extends StatefulWidget {
  final Produk produk;
  const OrderPage({super.key, required this.produk});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  late final TextEditingController _namaPemesanController;
  final _jumlahController = TextEditingController(text: '1');
  final _catatanController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final emailUser = FirebaseAuth.instance.currentUser?.email ?? '';
    _namaPemesanController = TextEditingController(text: emailUser);
  }

  @override
  void dispose() {
    _namaPemesanController.dispose();
    _jumlahController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  int get _totalHarga {
    final jumlah = int.tryParse(_jumlahController.text) ?? 0;
    return jumlah * widget.produk.harga;
  }

  Future<void> _order() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final pesananBaru = Pesanan(
      namaPemesan: _namaPemesanController.text,
      namaProduk: widget.produk.nama,
      jumlah: int.tryParse(_jumlahController.text) ?? 1,
      catatan: _catatanController.text,
    );

    try {
      await _apiService.tambahPesanan(pesananBaru);

      if (!mounted) return;

      // Notifikasi order berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF6F4E37),
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Pesanan berhasil dibuat!'),
            ],
          ),
        ),
      );

      // Pindah ke halaman Daftar Pesanan (ganti halaman ini,
      // supaya tidak bisa kembali ke form order yang sama)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PesananPage()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat pesanan.\nCek koneksi ke server. ($e)')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text('Pesan Kue'),
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kartu ringkasan produk
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFE0D0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.bakery_dining,
                          color: Color(0xFF8B5E3C)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.produk.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(widget.produk.kategori,
                              style: const TextStyle(color: Colors.black54)),
                          Text(
                            'Rp ${widget.produk.harga}',
                            style: const TextStyle(
                              color: Color(0xFF8B5E3C),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _namaPemesanController,
                decoration: _dekorasi('Nama Pemesan', Icons.person_outline),
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                decoration: _dekorasi('Jumlah', Icons.numbers_outlined),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Wajib diisi';
                  final n = int.tryParse(v);
                  if (n == null || n < 1) return 'Jumlah tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _catatanController,
                maxLines: 3,
                decoration: _dekorasi('Catatan (opsional)', Icons.note_alt_outlined),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE0D0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      'Rp $_totalHarga',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6F4E37),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _order,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5E3C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('ORDER SEKARANG',
                        style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dekorasi(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF8B5E3C)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}

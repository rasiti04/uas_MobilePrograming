import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_uts/models/pesanan.dart';
import 'package:project_uts/services/api_service.dart';

/// Form ini dipakai untuk 2 keperluan sekaligus:
/// - Jika [pesanan] null      -> mode TAMBAH (Create)
/// - Jika [pesanan] tidak null -> mode UBAH (Update)
class PesananFormPage extends StatefulWidget {
  final Pesanan? pesanan;
  const PesananFormPage({super.key, this.pesanan});

  @override
  State<PesananFormPage> createState() => _PesananFormPageState();
}

class _PesananFormPageState extends State<PesananFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  late final TextEditingController _namaPemesanController;
  late final TextEditingController _namaProdukController;
  late final TextEditingController _jumlahController;
  late final TextEditingController _catatanController;

  bool _isLoading = false;
  bool get _isEdit => widget.pesanan != null;

  @override
  void initState() {
    super.initState();
    final emailUser = FirebaseAuth.instance.currentUser?.email ?? '';

    _namaPemesanController = TextEditingController(
      text: widget.pesanan?.namaPemesan ?? emailUser,
    );
    _namaProdukController = TextEditingController(
      text: widget.pesanan?.namaProduk ?? '',
    );
    _jumlahController = TextEditingController(
      text: widget.pesanan != null ? widget.pesanan!.jumlah.toString() : '1',
    );
    _catatanController = TextEditingController(
      text: widget.pesanan?.catatan ?? '',
    );
  }

  @override
  void dispose() {
    _namaPemesanController.dispose();
    _namaProdukController.dispose();
    _jumlahController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final pesananBaru = Pesanan(
      namaPemesan: _namaPemesanController.text,
      namaProduk: _namaProdukController.text,
      jumlah: int.tryParse(_jumlahController.text) ?? 1,
      catatan: _catatanController.text,
      status: widget.pesanan?.status ?? 'Menunggu Konfirmasi',
    );

    try {
      if (_isEdit) {
        await _apiService.updatePesanan(widget.pesanan!.id!, pesananBaru);
      } else {
        await _apiService.tambahPesanan(pesananBaru);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menyimpan.\nCek koneksi ke server. ($e)',
            ),
          ),
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
        title: Text(_isEdit ? 'Ubah Pesanan' : 'Pesan Kue Baru'),
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
              TextFormField(
                controller: _namaPemesanController,
                decoration: _dekorasi('Nama Pemesan', Icons.person_outline),
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaProdukController,
                decoration: _dekorasi('Nama Produk', Icons.bakery_dining_outlined),
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
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
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _isLoading ? null : _simpan,
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
                    : Text(_isEdit ? 'SIMPAN PERUBAHAN' : 'PESAN SEKARANG'),
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

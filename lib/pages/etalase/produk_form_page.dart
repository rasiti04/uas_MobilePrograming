import 'package:flutter/material.dart';
import 'package:project_uts/models/produk.dart';
import 'package:project_uts/services/api_service.dart';

/// Form CRUD produk:
/// - [produk] null      -> mode TAMBAH (Create)
/// - [produk] tidak null -> mode UBAH (Update)
class ProdukFormPage extends StatefulWidget {
  final Produk? produk;
  const ProdukFormPage({super.key, this.produk});

  @override
  State<ProdukFormPage> createState() => _ProdukFormPageState();
}

class _ProdukFormPageState extends State<ProdukFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  late final TextEditingController _namaController;
  late final TextEditingController _hargaController;
  late final TextEditingController _kategoriController;

  bool _isLoading = false;
  bool get _isEdit => widget.produk != null;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.produk?.nama ?? '');
    _hargaController = TextEditingController(
      text: widget.produk != null ? widget.produk!.harga.toString() : '',
    );
    _kategoriController =
        TextEditingController(text: widget.produk?.kategori ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final produkBaru = Produk(
      nama: _namaController.text,
      harga: int.tryParse(_hargaController.text) ?? 0,
      kategori: _kategoriController.text,
    );

    try {
      if (_isEdit) {
        await _apiService.updateProduk(widget.produk!.id!, produkBaru);
      } else {
        await _apiService.tambahProduk(produkBaru);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan.\nCek koneksi ke server. ($e)')),
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
        title: Text(_isEdit ? 'Ubah Produk' : 'Tambah Produk'),
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
                controller: _namaController,
                decoration: _dekorasi('Nama Produk', Icons.bakery_dining_outlined),
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: _dekorasi('Harga (Rp)', Icons.payments_outlined),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(v) == null) return 'Harga harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kategoriController,
                decoration: _dekorasi('Kategori', Icons.category_outlined),
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
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
                    : Text(_isEdit ? 'SIMPAN PERUBAHAN' : 'TAMBAH PRODUK'),
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

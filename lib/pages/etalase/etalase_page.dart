import 'package:flutter/material.dart';
import 'package:project_uts/models/produk.dart';
import 'package:project_uts/pages/etalase/produk_form_page.dart';
import 'package:project_uts/pages/pesanan/order_page.dart';
import 'package:project_uts/services/api_service.dart';

/// Etalase Kue: menampilkan daftar produk bakery.
/// - Tap kartu produk -> ke halaman Order (buat pesanan)
/// - Tombol (+) -> tambah produk baru
/// - Menu titik tiga di tiap kartu -> ubah / hapus produk
class EtalasePage extends StatefulWidget {
  const EtalasePage({super.key});

  @override
  State<EtalasePage> createState() => _EtalasePageState();
}

class _EtalasePageState extends State<EtalasePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Produk>> _futureProduk;

  @override
  void initState() {
    super.initState();
    _muatUlang();
  }

  void _muatUlang() {
    setState(() {
      _futureProduk = _apiService.getProduk();
    });
  }

  Future<void> _hapus(Produk produk) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk?'),
        content: Text('"${produk.nama}" akan dihapus dari etalase.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi == true && produk.id != null) {
      try {
        await _apiService.hapusProduk(produk.id!);
        _muatUlang();
      } catch (e) {
        _tampilkanError(e);
      }
    }
  }

  void _tampilkanError(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Gagal terhubung ke server.\nCek alamat IP & pastikan server aktif.\n($e)',
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text('Etalase Kue'),
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B5E3C),
        onPressed: () async {
          final berhasil = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const ProdukFormPage()),
          );
          if (berhasil == true) _muatUlang();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _muatUlang(),
        child: FutureBuilder<List<Produk>>(
          future: _futureProduk,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF8B5E3C)),
              );
            }

            if (snapshot.hasError) {
              return _buildErrorState();
            }

            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return _buildEmptyState();
            }

            return GridView.builder(
              padding: const EdgeInsets.all(14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final p = list[index];
                return _buildProdukCard(p);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProdukCard(Produk p) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderPage(produk: p)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEFE0D0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.bakery_dining,
                    size: 48,
                    color: Color(0xFF8B5E3C),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.nama,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.more_vert, size: 18),
                        onSelected: (value) async {
                          if (value == 'edit') {
                            final berhasil = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProdukFormPage(produk: p),
                              ),
                            );
                            if (berhasil == true) _muatUlang();
                          } else if (value == 'hapus') {
                            _hapus(p);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Ubah')),
                          PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    p.kategori,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${p.harga}',
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
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bakery_dining_outlined, size: 64, color: Colors.black26),
                  SizedBox(height: 12),
                  Text('Belum ada produk.\nTekan tombol + untuk menambah.',
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 64, color: Colors.black26),
                  const SizedBox(height: 12),
                  const Text(
                    'Tidak bisa terhubung ke server.\nCek Pengaturan Server '
                    'di tab Pesanan, pastikan IP & port sudah benar dan '
                    'server backend sedang berjalan.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _muatUlang,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5E3C),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

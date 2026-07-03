import 'package:flutter/material.dart';
import 'package:project_uts/models/pesanan.dart';
import 'package:project_uts/pages/pesanan/pesanan_form_page.dart';
import 'package:project_uts/pages/settings/server_settings_page.dart';
import 'package:project_uts/services/api_service.dart';

// 1. TAMBAHKAN IMPORT HALAMAN BERHASIL DI SINI
// (Sesuaikan path/lokasi filenya jika Anda menaruhnya di folder lain)
import 'package:project_uts/pages/pesanan/pesanan_berhasil.dart'; 

/// Halaman ini menampilkan & mengelola pesanan customer.
/// Semua data diambil/diubah lewat REST API (backend/server.js)
/// melalui koneksi IP address di jaringan WiFi yang sama
/// -> menjawab soal No. 2 dan No. 3 penugasan.
class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Pesanan>> _futurePesanan;

  @override
  void initState() {
    super.initState();
    _muatUlang();
  }

  void _muatUlang() {
    setState(() {
      _futurePesanan = _apiService.getPesanan();
    });
  }

  Future<void> _hapus(Pesanan pesanan) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pesanan?'),
        content: Text('Pesanan "${pesanan.namaProduk}" akan dihapus.'),
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

    if (konfirmasi == true && pesanan.id != null) {
      try {
        await _apiService.hapusPesanan(pesanan.id!);
        _muatUlang();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pesanan dihapus')),
          );
        }
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
        title: const Text('Pesanan Saya'),
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_ethernet),
            tooltip: 'Pengaturan Server',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ServerSettingsPage(),
                ),
              );
              _muatUlang();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B5E3C),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final berhasil = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => const PesananFormPage(),
            ),
          );
          if (berhasil == true) _muatUlang();
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async => _muatUlang(),
        child: FutureBuilder<List<Pesanan>>(
          future: _futurePesanan,
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

            return ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final p = list[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFEFE0D0),
                      child: Icon(Icons.bakery_dining, color: Color(0xFF8B5E3C)),
                    ),
                    title: Text(
                      '${p.namaProduk} x${p.jumlah}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pemesan: ${p.namaPemesan}'),
                        if (p.catatan.isNotEmpty) Text('Catatan: ${p.catatan}'),
                        Text(
                          'Status: ${p.status}',
                          style: const TextStyle(
                            color: Color(0xFF8B5E3C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        // ============================================================
                        // KODE TOMBOL KONFIRMASI DITAMBAHKAN DI SINI:
                        // ============================================================
                        if (p.status == "Menunggu Konfirmasi") ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 38,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HalamanPesananBerhasil(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Konfirmasi Pesanan",
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                        // ============================================================
                      ],
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          final berhasil = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PesananFormPage(pesanan: p),
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
                  ),
                );
              },
            );
          },
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
                  Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.black26),
                  SizedBox(height: 12),
                  Text('Belum ada pesanan.\nTekan tombol + untuk memesan.',
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
                    'Tidak bisa terhubung ke server.\nPastikan:\n'
                    '1. Server backend sudah dijalankan (node server.js)\n'
                    '2. HP & komputer di WiFi yang sama\n'
                    '3. Alamat IP di Pengaturan Server sudah benar',
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
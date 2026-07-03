import 'package:flutter/material.dart';
import 'package:project_uts/services/server_config.dart';

/// Halaman untuk mengatur alamat IP + port server REST API lokal.
/// Ini penting karena soal No. 3 meminta koneksi ke server memakai
/// IP Address pada jaringan WiFi yang sama -> alamat IP bisa berubah
/// setiap kali ganti jaringan, jadi dibuat bisa diatur dari sini
/// tanpa perlu edit kode & build ulang aplikasi.
class ServerSettingsPage extends StatefulWidget {
  const ServerSettingsPage({super.key});

  @override
  State<ServerSettingsPage> createState() => _ServerSettingsPageState();
}

class _ServerSettingsPageState extends State<ServerSettingsPage> {
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    final ip = await ServerConfig.getIp();
    final port = await ServerConfig.getPort();
    setState(() {
      _ipController.text = ip;
      _portController.text = port;
      _loading = false;
    });
  }

  Future<void> _simpan() async {
    await ServerConfig.setServer(
      _ipController.text.trim(),
      _portController.text.trim(),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat server disimpan')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text('Pengaturan Server'),
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Masukkan alamat IP komputer tempat server REST API '
                    '(folder /backend) dijalankan. Pastikan HP dan komputer '
                    'terhubung ke WiFi yang sama.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _ipController,
                    decoration: InputDecoration(
                      labelText: 'IP Address (contoh: 192.168.1.5)',
                      prefixIcon: const Icon(Icons.wifi, color: Color(0xFF8B5E3C)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _portController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Port (default: 3000)',
                      prefixIcon: const Icon(Icons.numbers, color: Color(0xFF8B5E3C)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _simpan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5E3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('SIMPAN'),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_uts/models/pesanan.dart';
import 'package:project_uts/models/produk.dart';
import 'package:project_uts/services/server_config.dart';

/// Service untuk komunikasi dengan REST API server (folder /backend
/// atau /backend-laravel). Semua request memakai alamat IP yang
/// disimpan lewat [ServerConfig], supaya bisa diakses dari HP asal
/// masih dalam jaringan WiFi yang sama.
class ApiService {
  Future<String> _baseUrl() => ServerConfig.getBaseUrl();

  // ================= PRODUK (Etalase Kue) =================

  // READ - semua produk
  Future<List<Produk>> getProduk() async {
    final base = await _baseUrl();
    final response = await http
        .get(Uri.parse('$base/api/produkbakery'))
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Produk.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat produk (${response.statusCode})');
    }
  }

  // CREATE - tambah produk baru
  Future<Produk> tambahProduk(Produk produk) async {
    final base = await _baseUrl();
    final response = await http
        .post(
          Uri.parse('$base/api/produkbakery'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(produk.toJson()),
        )
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 201) {
      return Produk.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambah produk (${response.statusCode})');
    }
  }

  // UPDATE - ubah produk
  Future<Produk> updateProduk(int id, Produk produk) async {
    final base = await _baseUrl();
    final response = await http
        .put(
          Uri.parse('$base/api/produkbakery/$id'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(produk.toJson()),
        )
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      return Produk.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengubah produk (${response.statusCode})');
    }
  }

  // DELETE - hapus produk
  Future<void> hapusProduk(int id) async {
    final base = await _baseUrl();
    final response = await http
        .delete(Uri.parse('$base/api/produkbakery/$id'))
        .timeout(const Duration(seconds: 8));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus produk (${response.statusCode})');
    }
  }

  // ================= PESANAN =================

  // READ - ambil semua pesanan
  Future<List<Pesanan>> getPesanan() async {
    final base = await _baseUrl();
    final response = await http
        .get(Uri.parse('$base/api/pesanan'))
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Pesanan.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat pesanan (${response.statusCode})');
    }
  }

  // CREATE - tambah pesanan baru
  Future<Pesanan> tambahPesanan(Pesanan pesanan) async {
    final base = await _baseUrl();
    final response = await http
        .post(
          Uri.parse('$base/api/pesanan'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(pesanan.toJson()),
        )
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 201) {
      return Pesanan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambah pesanan (${response.statusCode})');
    }
  }

  // UPDATE - ubah pesanan
  Future<Pesanan> updatePesanan(int id, Pesanan pesanan) async {
    final base = await _baseUrl();
    final response = await http
        .put(
          Uri.parse('$base/api/pesanan/$id'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(pesanan.toJson()),
        )
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      return Pesanan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengubah pesanan (${response.statusCode})');
    }
  }

  // DELETE - hapus pesanan
  Future<void> hapusPesanan(int id) async {
    final base = await _baseUrl();
    final response = await http
        .delete(Uri.parse('$base/api/pesanan/$id'))
        .timeout(const Duration(seconds: 8));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus pesanan (${response.statusCode})');
    }
  }
}

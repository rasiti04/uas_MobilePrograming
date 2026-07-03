# Sweet Crumb Bakery App

Aplikasi Flutter bertema bakery untuk customer, dengan Firebase Authentication
(Login/Register), REST API CRUD (Produk & Pesanan), dan navigasi antar
halaman berbasis IP address di jaringan lokal.

## Struktur Halaman

1. **Login / Register** (`lib/pages/auth/`)
   - Login wajib sebelum masuk ke aplikasi utama
   - Setelah Register berhasil, user diarahkan balik ke halaman Login
     (bukan langsung login otomatis)

2. **Beranda** (`lib/pages/beranda/beranda_page.dart`)
   - Foto toko besar, Tentang Kami, No. Telepon, dan Lokasi (Maps)
     semuanya langsung tampil tanpa perlu diklik
   - Tombol Logout

3. **Etalase Kue** (`lib/pages/etalase/`)
   - Daftar produk dari REST API (GET /api/produk)
   - Tambah / Ubah / Hapus produk (CRUD penuh)
   - Tap produk -> ke halaman Order

4. **Order** (`lib/pages/pesanan/order_page.dart`)
   - Form order untuk 1 produk yang dipilih
   - Setelah tekan "ORDER SEKARANG" -> notifikasi "Pesanan berhasil"
     -> otomatis pindah ke halaman Daftar Pesanan

5. **Pesanan** (`lib/pages/pesanan/pesanan_page.dart`)
   - Daftar semua pesanan (GET /api/pesanan)
   - Ubah / Hapus pesanan
   - Ikon pengaturan (kanan atas) -> atur IP address & port server

## Koneksi ke Backend

Semua data (produk & pesanan) diambil dari REST API server yang berjalan
di komputer/laptop yang sama jaringan WiFi-nya dengan HP. Ada 2 pilihan
backend, pilih salah satu:

- `/backend` -> Node.js + Express (port default 3000)
- `/backend-laravel` -> Laravel (port default 8000)

Atur alamat IP & port lewat halaman **Pesanan -> ikon pengaturan (server icon)**.

## Firebase Authentication

`lib/firebase_options.dart` dan `android/app/google-services.json` sudah
diisi konfigurasi asli (bukan placeholder). Kalau mau ganti ke project
Firebase lain, jalankan ulang:
```
flutterfire configure --project=<project-id-firebase>
```

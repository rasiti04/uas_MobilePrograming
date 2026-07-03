class Pesanan {
  final int? id;
  final String namaPemesan;
  final String namaProduk;
  final int jumlah;
  final String catatan;
  final String status;

  Pesanan({
    this.id,
    required this.namaPemesan,
    required this.namaProduk,
    required this.jumlah,
    this.catatan = '',
    this.status = 'Menunggu Konfirmasi',
  });

  factory Pesanan.fromJson(Map<String, dynamic> json) {
    return Pesanan(
      id: json['id'],
      namaPemesan: json['nama_pemesan'] ?? '',
      namaProduk: json['nama_produk'] ?? '',
      jumlah: json['jumlah'] ?? 1,
      catatan: json['catatan'] ?? '',
      status: json['status'] ?? 'Menunggu Konfirmasi',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_pemesan': namaPemesan,
      'nama_produk': namaProduk,
      'jumlah': jumlah,
      'catatan': catatan,
      'status': status,
    };
  }
}

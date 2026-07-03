class Produk {
  final int? id;
  final String nama;
  final int harga;
  final String kategori;

  Produk({
    this.id,
    required this.nama,
    required this.harga,
    required this.kategori,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      nama: json['nama'] ?? '',
      harga: json['harga'] is String
          ? int.tryParse(json['harga']) ?? 0
          : (json['harga'] ?? 0),
      kategori: json['kategori'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'harga': harga,
      'kategori': kategori,
    };
  }
}

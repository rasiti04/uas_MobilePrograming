<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pesanan extends Model
{
    use HasFactory;

    // Nama tabel di database
    protected $table = 'pesanan';

    // Kolom yang boleh diisi lewat mass-assignment (create/update)
    protected $fillable = [
        'nama_pemesan',
        'nama_produk',
        'jumlah',
        'catatan',
        'status',
    ];

    // Nilai default kalau status tidak dikirim dari Flutter
    protected $attributes = [
        'status' => 'Menunggu Konfirmasi',
    ];
}

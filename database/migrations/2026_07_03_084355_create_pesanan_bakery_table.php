<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Jalankan migration -> membuat tabel pesanan.
     */
    public function up(): void
    {
        Schema::create('pesanan', function (Blueprint $table) {
            $table->id();
            $table->string('nama_pemesan');
            $table->string('nama_produk');
            $table->integer('jumlah')->default(1);
            $table->text('catatan')->nullable();
            $table->string('status')->default('Menunggu Konfirmasi');
            $table->timestamps();
        });
    }

    /**
     * Batalkan migration -> hapus tabel pesanan.
     */
    public function down(): void
    {
        Schema::dropIfExists('pesanan');
    }
};

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('produk', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->integer('harga');
            $table->string('kategori');
            $table->timestamps();
        });

        // Isi beberapa data awal (opsional, biar etalase tidak kosong)
        DB::table('produk')->insert([
            ['nama' => 'Roti Coklat', 'harga' => 12000, 'kategori' => 'Roti Manis', 'created_at' => now(), 'updated_at' => now()],
            ['nama' => 'Roti Tawar', 'harga' => 15000, 'kategori' => 'Roti Tawar', 'created_at' => now(), 'updated_at' => now()],
            ['nama' => 'Croissant Butter', 'harga' => 18000, 'kategori' => 'Pastry', 'created_at' => now(), 'updated_at' => now()],
            ['nama' => 'Donat Gula', 'harga' => 8000, 'kategori' => 'Donat', 'created_at' => now(), 'updated_at' => now()],
            ['nama' => 'Black Forest Slice', 'harga' => 25000, 'kategori' => 'Kue', 'created_at' => now(), 'updated_at' => now()],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('produk');
    }
};

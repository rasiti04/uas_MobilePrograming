<?php

namespace App\Http\Controllers;

use App\Models\ProdukBakery;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ProdukBakeryController extends Controller
{
    /**
     * READ - semua produk
     * GET /api/produk
     */
    public function index()
    {
        $produk = ProdukBakery::orderBy('created_at', 'desc')->get();

        return response()->json($produk, 200);
    }

    /**
     * READ - detail 1 produk
     * GET /api/produk/{id}
     */
    public function show($id)
    {
        $produk = ProdukBakery::find($id);

        if (!$produk) {
            return response()->json([
                'message' => 'Produk tidak ditemukan'
            ], 404);
        }

        return response()->json($produk, 200);
    }

    /**
     * CREATE - tambah produk baru
     * POST /api/produk
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama'     => 'required|string|max:255',
            'harga'    => 'required|integer|min:0',
            'kategori' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Nama, harga, dan kategori wajib diisi',
                'errors'  => $validator->errors(),
            ], 400);
        }

        $produk = ProdukBakery::create([
            'nama'     => $request->nama,
            'harga'    => $request->harga,
            'kategori' => $request->kategori,
        ]);

        return response()->json([
            'message' => 'Produk berhasil ditambahkan',
            'data'    => $produk
        ], 201);
    }

    /**
     * UPDATE - ubah produk
     * PUT /api/produk/{id}
     */
    public function update(Request $request, $id)
    {
        $produk = ProdukBakery::find($id);

        if (!$produk) {
            return response()->json([
                'message' => 'Produk tidak ditemukan'
            ], 404);
        }

        $produk->update([
            'nama'     => $request->nama ?? $produk->nama,
            'harga'    => $request->harga ?? $produk->harga,
            'kategori' => $request->kategori ?? $produk->kategori,
        ]);

        return response()->json([
            'message' => 'Produk berhasil diperbarui',
            'data'    => $produk
        ], 200);
    }

    /**
     * DELETE - hapus produk
     * DELETE /api/produk/{id}
     */
    public function destroy($id)
    {
        $produk = ProdukBakery::find($id);

        if (!$produk) {
            return response()->json([
                'message' => 'Produk tidak ditemukan'
            ], 404);
        }

        $produk->delete();

        return response()->json([
            'message' => 'Produk berhasil dihapus',
            'data'    => $produk
        ], 200);
    }
}
<?php

namespace App\Http\Controllers;

use App\Models\Pesanan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PesananController extends Controller
{
    /**
     * READ - semua pesanan
     * GET /api/pesanan
     */
    public function index()
    {
        $pesanan = Pesanan::orderBy('created_at', 'desc')->get();

        return response()->json($pesanan, 200);
    }

    /**
     * READ - detail 1 pesanan
     * GET /api/pesanan/{id}
     */
    public function show($id)
    {
        $pesanan = Pesanan::find($id);

        if (!$pesanan) {
            return response()->json([
                'message' => 'Pesanan tidak ditemukan'
            ], 404);
        }

        return response()->json($pesanan, 200);
    }

    /**
     * CREATE - tambah pesanan baru
     * POST /api/pesanan
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama_pemesan' => 'required|string|max:255',
            'nama_produk'  => 'required|string|max:255',
            'jumlah'       => 'required|integer|min:1',
            'catatan'      => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Nama pemesan, nama produk, dan jumlah wajib diisi',
                'errors'  => $validator->errors(),
            ], 400);
        }

        $pesanan = Pesanan::create([
            'nama_pemesan' => $request->nama_pemesan,
            'nama_produk'  => $request->nama_produk,
            'jumlah'       => $request->jumlah,
            'catatan'      => $request->catatan ?? '',
            'status'       => 'Menunggu Konfirmasi',
        ]);

        return response()->json([
            'message' => 'Pesanan berhasil ditambahkan',
            'data'    => $pesanan
        ], 201);
    }

    /**
     * UPDATE - ubah pesanan
     * PUT /api/pesanan/{id}
     */
    public function update(Request $request, $id)
    {
        $pesanan = Pesanan::find($id);

        if (!$pesanan) {
            return response()->json([
                'message' => 'Pesanan tidak ditemukan'
            ], 404);
        }

        $pesanan->update([
            'nama_pemesan' => $request->nama_pemesan ?? $pesanan->nama_pemesan,
            'nama_produk'  => $request->nama_produk ?? $pesanan->nama_produk,
            'jumlah'       => $request->jumlah ?? $pesanan->jumlah,
            'catatan'      => $request->catatan ?? $pesanan->catatan,
            'status'       => $request->status ?? $pesanan->status,
        ]);

        return response()->json([
            'message' => 'Pesanan berhasil diperbarui',
            'data'    => $pesanan
        ], 200);
    }

    /**
     * DELETE - hapus pesanan
     * DELETE /api/pesanan/{id}
     */
    public function destroy($id)
    {
        $pesanan = Pesanan::find($id);

        if (!$pesanan) {
            return response()->json([
                'message' => 'Pesanan tidak ditemukan'
            ], 404);
        }

        $pesanan->delete();

        return response()->json([
            'message' => 'Pesanan berhasil dihapus',
            'data'    => $pesanan
        ], 200);
    }
}
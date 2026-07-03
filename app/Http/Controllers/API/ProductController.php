<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{
    public function index()
    {
        $product = Product::all();

        return response()->json([
            'success' => true,
            'message' => 'Data Product',
            'data' => $product
        ], 200);
    }

    public function store(Request $request)
    {
        $validate = $request->validate([
            'name' => 'required|string|max:255',
            'image' => 'nullable|image|mimes:jpg,jpeg,png',
            'descriptions' => 'required|string|max:1000',
            'price' => 'required',
            'stock' => 'required|integer|min:0',
        ]);

        if ($request->hasFile('image')) {
            $validate['image'] = $request->file('image')
                ->store('products', 'public');
        }

        $product = Product::create($validate);

        return response()->json([
            'success' => true,
            'message' => 'Data berhasil ditambahkan',
            'data' => $product
        ], 201);
    }

    public function show($id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Detail Product',
            'data' => $product
        ], 200);
    }

    public function update(Request $request, $id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ], 404);
        }

        $validate = $request->validate([
            'name' => 'required|string|max:255',
            'image' => 'nullable|image|mimes:jpg,jpeg,png',
            'descriptions' => 'required|string',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
        ]);

        if ($request->hasFile('image')) {

            if ($product->image &&
                Storage::disk('public')->exists($product->image)) {

                Storage::disk('public')->delete($product->image);
            }

            $validate['image'] = $request->file('image')
                ->store('products', 'public');
        } else {
            $validate['image'] = $product->image;
        }

        $product->update($validate);

        return response()->json([
            'success' => true,
            'message' => 'Data berhasil diperbarui',
            'data' => $product
        ], 200);
    }

    public function destroy($id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ], 404);
        }

        if ($product->image &&
            Storage::disk('public')->exists($product->image)) {

            Storage::disk('public')->delete($product->image);
        }

        $product->delete();

        return response()->json([
            'success' => true,
            'message' => 'Data berhasil dihapus'
        ], 200);
    }
}
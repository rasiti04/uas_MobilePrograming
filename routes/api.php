<?php
use App\Http\Controllers\PesananController;
use App\Http\Controllers\ProdukbakeryController;
use App\Http\Controllers\API\ProductController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes - Sweet Crumb Bakery (khusus customer)
|--------------------------------------------------------------------------
| Semua route di sini otomatis diawali prefix "/api" oleh Laravel.
| Jadi endpoint aslinya jadi:
|   GET    /api/produk
|   POST   /api/produk
|   PUT    /api/produk/{id}
|   DELETE /api/produk/{id}
|   GET    /api/pesanan
|   GET    /api/pesanan/{id}
|   POST   /api/pesanan
|   PUT    /api/pesanan/{id}
|   DELETE /api/pesanan/{id}
*/

Route::get('/produk', [ProdukbakeryController::class, 'index']);
Route::get('/produk/{id}', [ProdukbakeryController::class, 'show']);
Route::post('/produk', [ProdukbakeryController::class, 'store']);
Route::put('/produk/{id}', [ProdukbakeryController::class, 'update']);
Route::delete('/produk/{id}', [ProdukbakeryController::class, 'destroy']);

Route::get('/pesanan', [PesananController::class, 'index']);
Route::get('/pesanan/{id}', [PesananController::class, 'show']);
Route::post('/pesanan', [PesananController::class, 'store']);
Route::put('/pesanan/{id}', [PesananController::class, 'update']);
Route::delete('/pesanan/{id}', [PesananController::class, 'destroy']);

Route::apiResource('produkbakery', ProdukBakeryController::class);




Route::apiResource('products', ProductController::class);

Route::post(
    'products/{id}/upload-image',
    [ProductController::class, 'uploadImage']
);

// Route custom untuk mengurangi stok
Route::patch(
    'products/{id}/reduce-stock',
    [ProductController::class, 'reduceStock']
);

// Akses gambar via API
Route::get('/image/{filename}', function ($filename) {

    $path = storage_path('app/public/products/' . $filename);

    if (!file_exists($path)) {
        return response()->json([
            'error' => 'Image not found'
        ], 404);
    }

    return response()->file($path, [
        'Access-Control-Allow-Origin' => '*'
    ]);

})->where('filename', '.*');

// Check API
Route::get('/check', function () {
    return response()->json([
        'message' => 'API route works'
    ]);
});
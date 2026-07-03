<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ProductController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

// Route Cetak PDF
Route::get('/product/cetak-pdf', [ProductController::class, 'cetakPdf'])
    ->name('product.cetakPdf');

Route::middleware('auth')->group(function () {

    Route::get('/profile', [ProfileController::class, 'edit'])
        ->name('profile.edit');

    Route::patch('/profile', [ProfileController::class, 'update'])
        ->name('profile.update');

    Route::delete('/profile', [ProfileController::class, 'destroy'])
        ->name('profile.destroy');

    // Tambahan route untuk photo profile
    Route::post('/profile/photo', [ProfileController::class, 'updatePhoto'])
        ->name('profile.photo.update');

    Route::delete('/profile/photo', [ProfileController::class, 'deletePhoto'])
        ->name('profile.photo.destroy');

    // Route Product
    Route::get('/product', [ProductController::class, 'index'])
        ->name('product.index');

    Route::get('/product/create', [ProductController::class, 'create'])
        ->name('product.create');

    Route::post('/product', [ProductController::class, 'store'])
        ->name('product.store');

    Route::get('/product/{id}', [ProductController::class, 'show'])
        ->name('product.show');

    Route::get('/product/{id}/edit', [ProductController::class, 'edit'])
        ->name('product.edit');

    Route::put('/product/{id}', [ProductController::class, 'update'])
        ->name('product.update');

    Route::delete('/product/{id}', [ProductController::class, 'destroy'])
        ->name('product.destroy');
});

require __DIR__.'/auth.php';
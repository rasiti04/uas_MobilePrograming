
{{-- resources/views/product/edit.blade.php --}}
<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            Edit Produk
        </h2>
    </x-slot>

    <div class="py-6 max-w-4xl mx-auto">
        <div class="bg-yellow p-6 rounded shadow">

            <form action="{{ route('product.update', $product->id) }}" method="POST" enctype="multipart/form-data">
                @csrf
                @method('PUT')

                {{-- NAMA --}}
                <div class="mb-4">
                    <label>Nama</label>
                    <input
                        type="text"
                        name="name"
                        value="{{ old('name', $product->name) }}"
                        class="w-full border rounded p-2">

                    @error('name')
                        <small class="text-red-600">{{ $message }}</small>
                    @enderror
                </div>

                {{-- GAMBAR --}}
                <div class="mb-4">
                    <label>Gambar</label>
                    <input
                        type="file"
                        name="image"
                        accept="image/*"
                        class="w-full border rounded p-2">

                    @error('image')
                        <small class="text-red-600">{{ $message }}</small>
                    @enderror
                </div>

                {{-- TAMPILKAN GAMBAR SAAT INI --}}
                @if ($product->image)
                    <div class="mb-4">
                        <p class="text-sm text-gray-600">
                            Gambar saat ini :
                        </p>

                        <img
                            src="{{ asset('storage/' . $product->image) }}"
                            alt="Product Image"
                            width="120"
                            class="rounded shadow">
                    </div>
                @endif

                {{-- DESCRIPTIONS --}}
                <div class="mb-4">
                    <label>Descriptions</label>
                    <textarea
                        name="descriptions"
                        class="w-full border rounded p-2">{{ old('descriptions', $product->descriptions) }}</textarea>

                    @error('descriptions')
                        <small class="text-red-600">{{ $message }}</small>
                    @enderror
                </div>

                {{-- PRICE --}}
                <div class="mb-4">
                    <label>Price</label>
                    <input
                        type="text"
                        name="price"
                        value="{{ old('price', $product->price) }}"
                        class="w-full border rounded p-2">

                    @error('price')
                        <small class="text-red-600">{{ $message }}</small>
                    @enderror
                </div>

                {{-- STOCK --}}
                <div class="mb-4">
                    <label>Stock</label>
                    <input
                        type="number"
                        name="stock"
                        value="{{ old('stock', $product->stock) }}"
                        class="w-full border rounded p-2">

                    @error('stock')
                        <small class="text-red-600">{{ $message }}</small>
                    @enderror
                </div>

                <button class="bg-blue-600 text-gray px-4 py-2 rounded">
                    Update
                </button>

                <a href="{{ route('product.index') }}" class="ml-2 text-gray-600">
                    Batal
                </a>

            </form>

        </div>
    </div>
</x-app-layout>


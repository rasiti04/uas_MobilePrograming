
{{-- resources/views/product/create.blade.php --}}
<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            Tambah Produk
        </h2>
    </x-slot>

    <div class="py-6 max-w-4xl mx-auto">
        <div class="bg-white p-6 rounded shadow">

            <form action="{{ route('product.store') }}" method="POST" enctype="multipart/form-data">
                @csrf

                {{-- Nama --}}
                <div class="mb-4">
                    <label class="block mb-1">Nama</label>
                    <input
                        type="text"
                        name="name"
                        value="{{ old('name') }}"
                        class="w-full border rounded p-2">

                    @error('name')
                        <small class="text-red-600">{{ $message }}</small>
                    @enderror
                </div>

                {{-- Gambar --}}
                <div class="mb-4">
                    <label class="block mb-1">Gambar</label>
                    <input
                        type="file"
                        name="image"
                        accept="image/*"
                        class="w-full border rounded p-2">

                    @error('image')
                        <small class="text-red-600">{{ $message }}</small>
                    @enderror
                </div>

                {{-- Descriptions --}}
                <div class="mb-4">
                    <label class="block mb-1">Descriptions</label>
                    <input
                        type="text"
                        name="descriptions"
                        value="{{ old('descriptions') }}"
                        class="w-full border rounded p-2">

                    @error('descriptions')
                        <small class="text-red-600">{{ $message }}</small>
                    @enderror
                </div>

                {{-- Price --}}
                <div class="mb-4">
                    <label class="block mb-1">Price</label>
                    <input
                        type="text"
                        name="price"
                        value="{{ old('price') }}"
                        class="w-full border rounded p-2">

                    @error('price')
                        <small class="text-red-600">{{ $message }}</small>
                    @enderror
                </div>

                {{-- Stock --}}
                <div class="mb-4">
                    <label class="block mb-1">Stock</label>
                    <input
                        type="number"
                        name="stock"
                        id="stock"
                        class="w-full border rounded p-2">

                    @error('stock')
                        <small class="text-red-600">{{ $message }}</small>
                    @enderror
                </div>

                {{-- Buttons --}}
               <button class="bg-blue-600 text-white px-4 py-2 rounded">
                Simpan
               </button>

                <a href="{{ route('product.index') }}" class="ml-2 text-gray-600">
                    Batal
                </a>

            </form>

        </div>
    </div>
</x-app-layout>


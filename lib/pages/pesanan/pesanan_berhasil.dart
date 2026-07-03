import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import halaman detail_pesanan yang akan kita buat di bawah
import 'detail_pesanan.dart'; 

class HalamanPesananBerhasil extends StatefulWidget {
  const HalamanPesananBerhasil({super.key});

  @override
  State<HalamanPesananBerhasil> createState() => _HalamanPesananBerhasilState();
}

class _HalamanPesananBerhasilState extends State<HalamanPesananBerhasil> {
  String? _metodePengiriman = 'Ambil Sendiri';
  final List<String> _opsiPengiriman = ['Ambil Sendiri', 'Delivery', 'Gojek/Grab'];

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _cabangTerpilih = 'Bakery Pusat - Tangerang';

  final List<String> _cabangBakery = [
    'Bakery Pusat - Tangerang',
    'Bakery Cabang - Jakarta Barat',
    'Bakery Cabang - Bandung',
    'Bakery Cabang - Surabaya',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text("Lengkapi Informasi"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  SizedBox(height: 12),
                  Text(
                    "Langkah Terakhir!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(height: 30),

            // 1. AUTOCOMPLETE
            const Text("Pilih Cabang Pengambilan:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Autocomplete<String>(
              initialValue: TextEditingValue(text: _cabangTerpilih),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') return const Iterable<String>.empty();
                return _cabangBakery.where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (selection) {
                setState(() => _cabangTerpilih = selection);
              },
            ),
            const SizedBox(height: 16),

            // 2. SPINNER / DROPDOWN
            const Text("Metode Pengiriman:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _metodePengiriman,
              items: _opsiPengiriman.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (newValue) => setState(() => _metodePengiriman = newValue),
              decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
            ),
            const SizedBox(height: 16),

            // 3. DATE & TIME PICKER
            const Text("Jadwal Pengambilan:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(DateFormat('dd-MM-yyyy').format(_selectedDate)),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time, size: 18),
                    label: Text(_selectedTime.format(context)),
                    onPressed: () => _selectTime(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // TOMBOL MENUJU KE HALAMAN DETAIL STRUK NEW FILE
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HalamanDetailPesanan(
                        cabang: _cabangTerpilih,
                        metode: _metodePengiriman ?? 'Ambil Sendiri',
                        tanggal: DateFormat('dd-MM-yyyy').format(_selectedDate),
                        jam: _selectedTime.format(context),
                      ),
                    ),
                  );
                },
                child: const Text("Lihat Detail Struk Pesanan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
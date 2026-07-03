import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:project_uts/firebase_options.dart';
import 'package:project_uts/pages/auth/auth_gate.dart';
import 'package:project_uts/pages/beranda/beranda_page.dart';
import 'package:project_uts/pages/etalase/etalase_page.dart';
import 'package:project_uts/pages/pesanan/pesanan_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase (untuk fitur Login & Register).
  // Jika belum menjalankan `flutterfire configure`, baris ini akan
  // menimbulkan error - itu tandanya file firebase_options.dart
  // masih placeholder dan perlu diisi konfigurasi Firebase asli.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sweet Crumb Bakery',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5E3C),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    BerandaPage(),
    EtalasePage(),
    PesananPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.storefront),
            title: const Text("Beranda"),
            selectedColor: const Color(0xFF8B5E3C),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.bakery_dining),
            title: const Text("Etalase"),
            selectedColor: const Color(0xFF6F4E37),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.receipt_long),
            title: const Text("Pesanan"),
            selectedColor: const Color(0xFFB08968),
          ),
        ],
      ),
    );
  }
}
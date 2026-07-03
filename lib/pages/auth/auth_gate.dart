import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_uts/main.dart';
import 'package:project_uts/pages/auth/login_page.dart';
import 'package:project_uts/services/auth_service.dart';

/// AuthGate memantau status login Firebase secara real-time.
/// - Jika belum login -> tampilkan LoginPage
/// - Jika sudah login  -> tampilkan HomePage (menu utama bakery)
///
/// Inilah bagian yang menggabungkan soal No. 1 (Firebase Auth) dan
/// No. 3 (Navigator) sesuai penugasan.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFFF8F0),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF8B5E3C)),
            ),
          );
        }

        if (snapshot.hasData) {
          // Sudah login -> masuk ke aplikasi utama
          return const HomePage();
        }

        // Belum login -> tampilkan halaman login
        return const LoginPage();
      },
    );
  }
}

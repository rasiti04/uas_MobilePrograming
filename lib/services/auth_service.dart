import 'package:firebase_auth/firebase_auth.dart';

/// Membungkus semua pemanggilan Firebase Authentication
/// (login, register, logout) supaya UI (halaman login/register)
/// tidak perlu berurusan langsung dengan FirebaseAuth.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> login(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> register(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  /// Menerjemahkan kode error Firebase ke pesan Bahasa Indonesia
  /// yang lebih mudah dipahami pengguna.
  String pesanError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Email belum terdaftar. Silakan daftar dulu.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau password salah.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan login.';
      case 'weak-password':
        return 'Password terlalu lemah (minimal 6 karakter).';
      case 'invalid-email':
        return 'Format email tidak valid.';
      default:
        return e.message ?? 'Terjadi kesalahan, coba lagi.';
    }
  }
}

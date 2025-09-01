import 'package:flutter/material.dart';
import 'package:project_2/app_crud/MainScreen/home_screen.dart';
import 'package:project_2/app_crud/screens/register_screen.dart';
import 'package:project_2/app_crud/services/auth_prefs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // key untuk mengontrol validasi form login
  final _formKey = GlobalKey<FormState>();
  // controller untuk mengambil teks dari input email
  final _emailController = TextEditingController();
  // controller untuk mengambil teks dari input password
  final _passwordController = TextEditingController();
  // indikator apakah sedang loading (misalnya menunggu proses login)
  bool _isLoading = false;
  // indikator apakah password disembunyikan atau ditampilkan
  bool _obscurePassword = true;
  @override
  void dispose() {
    // hapus controller email dari memory saat widget dihancurkan
    _emailController.dispose();
    // hapus controller password dari memory saat widget dihancurkan
    _passwordController.dispose();
    // panggil dispose bawaan
    super.dispose();
  }

  Future<void> _login() async {
    // cek validasi form, kalau tidak valid → hentikan fungsi
    if (!_formKey.currentState!.validate()) return;

    // ubah state jadi loading = true
    setState(() {
      _isLoading = true;
    });

    try {
      // cek apakah email dan password valid dengan AuthPreferences
      final isValid = await AuthPreferences.validateCredentials(
        _emailController.text.trim(), // ambil email tanpa spasi
        _passwordController.text.trim(), // ambil password tanpa spasi
      );

      if (isValid) {
        // kalau valid → simpan data login user
        await AuthPreferences.loginUser(
          'User', // sementara hardcode nama user "User"
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // pastikan widget masih aktif (tidak dispose)
        if (mounted) {
          // pindah ke halaman BookListScreen dan hapus halaman login dari stack
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        // kalau email/password salah → tampilkan SnackBar merah
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email atau password salah'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // kalau ada error saat proses login (misal DB error) → tampilkan SnackBar merah
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat login'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // apapun hasilnya (berhasil/gagal), matikan indikator loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Image/book1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Title
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        size: 50,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masuk ke akun Anda',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 40),
                    // Login Form
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!value.contains('@')) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Masuk'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Belum punya akun? '),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

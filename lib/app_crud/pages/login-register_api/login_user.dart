import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_2/app_crud/MainScreen/Bottom/mainscreen.dart';
import 'package:project_2/app_crud/pages/Api/authentication.dart';
import 'package:project_2/app_crud/pages/login-register_api/register_user.dart';

class UserLogin extends StatefulWidget {
  static const String routeName = '/login';
  const UserLogin({super.key});
  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final bool _isLoading = false;

  bool _obscurePassword = true;
  @override
  void _showLottieDialog() {
    final parentContext = context; // simpan context luar

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          content: SizedBox(height: 150, width: 150, child: Text("yooo")),
        );
      },
    );

    // Auto close setelah 1 detik
    Timer(const Duration(seconds: 2), () {
      if (mounted && Navigator.canPop(parentContext)) {
        Navigator.pop(parentContext);
      }
    });
  }

  final bool _password = true;

  Widget socialButton(String assetPath, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 40,
        child: InkWell(
          onTap: onTap,
          child: Container(
            child: Image.asset(assetPath, height: 24, width: 24),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPeserta(); // <--- ambil data dulu dari SQLite
  }

  Future<void> _loadPeserta() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Container(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Title
                    SizedBox(height: 50),
                    SizedBox(
                      height: 50,
                      child: Image(
                        image: AssetImage("assets/images/foto/logo.png"),
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
                      height: 495,
                      padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                        ),
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
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: "static",
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Email Field
                          TextFormField(
                            controller: emailController,
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
                          const SizedBox(height: 30),
                          // Password Field
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.emailAddress,
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

                          // Button Forgot Password dengan style text
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Navigasi ke halaman lupa password
                                // Navigator.push(
                                //   context,
                                //   // MaterialPageRoute(
                                //   //   builder: (context) => ForgotPasswordScreen(),
                                //   // ),
                                // );
                              },
                              child: Text(
                                'Lupa Password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final email = emailController.text.trim();
                                  final password = passwordController.text
                                      .trim();

                                  try {
                                    // 🔹 Panggil API login
                                    final user =
                                        await AuthenticationAPI.loginUser(
                                          email: email,
                                          password: password,
                                        );

                                    // ✅ Login sukses → tampilkan dialog dengan Lottie
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: SizedBox(
                                            height: 150,
                                            width: 150,
                                            child: Lottie.asset(
                                              'assets/lottie/otp.json',
                                              repeat: false,
                                              onLoaded: (composition) {
                                                Future.delayed(
                                                  composition.duration,
                                                  () {
                                                    if (mounted) {
                                                      Navigator.pop(
                                                        context,
                                                      ); // Tutup dialog
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MainScreen(),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } catch (e) {
                                    // ❌ Kalau login gagal → tampilkan dialog error
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(e.toString()),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Masuk'),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Register Link
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Belum punya akun? '),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      RegisterUser.routeName,
                                    );
                                  },
                                  child: const Text(
                                    'Daftar',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

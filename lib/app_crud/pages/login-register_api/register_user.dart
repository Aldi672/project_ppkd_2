import 'package:flutter/material.dart';
import 'package:project_2/app_crud/home.dart';
import 'package:project_2/app_crud/pages/Api/authentication.dart';
import 'package:project_2/app_crud/pages/login-register_api/login_user.dart';

class RegisterUser extends StatefulWidget {
  static const String routeName = '/register';
  const RegisterUser({super.key});
  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool _password = true;
  bool _confirmPassword = true;
  bool _isLoading = false;

  /// 🔹 Register dari form input
  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 🔹 Register ke API dengan data dari input user
      final user = await AuthenticationAPI.registerUser(
        name: namaController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      print("Register sukses: ${user?.data.user.name}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${user?.message}!"),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pop(context, true); // balik ke login
    } catch (e) {
      print("Error register: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 🔹 Login dari form input
  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final user = await AuthenticationAPI.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      print("Login sukses: Token ${user?.data.token}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login sukses"), backgroundColor: Colors.green),
      );

      // pindah ke halaman home/dashboard
      Navigator.pushReplacementNamed(context, BookApp.routeName);
    } catch (e) {
      print("Error login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login gagal: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 🔹 Logout
  Future<void> _logout() async {
    await AuthenticationAPI.logoutUser();
    print("Berhasil logout");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Logout berhasil"),
        backgroundColor: Colors.blue,
      ),
    );

    // kembali ke login
    Navigator.pushReplacementNamed(context, UserLogin.routeName);
  }

  // Navigate to book list

  // }

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
                    SizedBox(height: 32),
                    SizedBox(
                      height: 50,
                      child: Image(
                        image: AssetImage("assets/images/foto/logo.png"),
                      ),
                    ),
                    const SizedBox(height: 26),

                    const Text(
                      'Daftar Sekarang',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Register Form
                    Container(
                      height: 490,
                      padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0),
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
                              'Register',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: "static",
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: namaController,
                            decoration: const InputDecoration(
                              labelText: 'Nama Pengguna',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama pengguna tidak boleh kosong';
                              }
                              if (value.length < 3) {
                                return 'Nama pengguna minimal 3 karakter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
                          // Password Field
                          TextFormField(
                            controller: passwordController,
                            obscureText: _password,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _password
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _password = !_password;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              if (value.length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Confirm Password Field
                          TextFormField(
                            controller: confirmController,
                            obscureText: _confirmPassword,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Konfirmasi Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPassword = !_confirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi password tidak boleh kosong';
                              }
                              if (value != passwordController.text) {
                                return 'Password tidak cocok';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _registerUser,
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Daftar'),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Back to Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun? '),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Masuk',
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

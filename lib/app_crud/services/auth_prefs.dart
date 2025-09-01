// ignore_for_file: unused_local_variable

import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyUserPassword =
      'user_password'; // In real app, never store password
  // Login user
  static Future<bool> loginUser(String username, String email, String password)
  //Mengecek apakah email & password yang dimasukkan sama dengan yang tersimpan
  async {
    final prefs = await SharedPreferences.getInstance();
    // validasi terlebih dahulu
    final savedEmail = prefs.getString(_keyEmail) ?? '';
    final savedPassword = prefs.getString(_keyUserPassword) ?? '';
    // Simple validation - in real app, validate against backend
    if (email == savedEmail && password == savedPassword) {
      // jika cocok, set isLoggedIn ke true
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    }
    return false;
  }

  // Menyimpan data user baru
  static Future<bool> registerUser(
    String username,
    String email,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    // Simple validation - in real app, validate and store in backend
    if (username.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUsername, username);
      await prefs.setString(_keyEmail, email);
      await prefs.setString(
        _keyUserPassword,
        password,
      ); // Don't do this in real app
      return true;
    }
    return false;
  }

  // Mengecek apakah user sudah login atau belum
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Mengambil data user yang tersimpan.
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? 'User';
  }

  // Mengambil data user yang tersimpan.
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? '';
  }

  // supaya user dianggap logout.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  // Mengecek apakah email & password sesuai.
  static Future<bool> validateCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_keyEmail) ?? '';
    final savedPassword = prefs.getString(_keyUserPassword) ?? '';
    return email == savedEmail && password == savedPassword;
  }

  // Mengecek apakah user dengan email tertentu sudah terdaftar.
  static Future<bool> userExists(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_keyEmail) ?? '';
    return savedEmail == email;
  }
}

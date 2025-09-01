import 'package:http/http.dart' as http;
import 'package:project_2/app_crud/models/registrasi_api.dart';
import 'package:project_2/app_crud/pages/Api/endpoint/endpoint.dart';
import 'package:project_2/app_crud/preference/shared_preference.dart';

class AuthenticationAPI {
  // Ganti dengan URL API kamu

  /// ✅ Register User
  static Future<RegistrasiUserApi?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.register);

    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );

    if (response.statusCode == 200) {
      final data = registrasiUserApiFromJson(response.body);

      // Simpan data ke SharedPreferences
      await PreferenceHandler.saveLogin();
      await PreferenceHandler.saveToken(data.data.token);
      await PreferenceHandler.saveUserData(
        data.data.user.name,
        data.data.user.email,
      );
      await PreferenceHandler.saveUserId(data.data.user.id);

      return data;
    } else {
      throw Exception("Register gagal: ${response.body}");
    }
  }

  /// ✅ Login User
  static Future<RegistrasiUserApi?> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login);
    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      final data = registrasiUserApiFromJson(response.body);

      // Simpan data ke SharedPreferences
      await PreferenceHandler.saveLogin();
      await PreferenceHandler.saveToken(data.data.token);
      await PreferenceHandler.saveUserData(
        data.data.user.name,
        data.data.user.email,
      );
      await PreferenceHandler.saveUserId(data.data.user.id);

      return data;
    } else {
      throw Exception("Login gagal: ${response.body}");
    }
  }

  /// ✅ Logout User
  static Future<void> logoutUser() async {
    await PreferenceHandler.clearAll();
  }

  /// ✅ Cek apakah sudah login
  static Future<bool> isLoggedIn() async {
    return await PreferenceHandler.getLogin();
  }
}

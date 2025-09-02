import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_2/app_crud/models/card_user.dart';
import 'package:project_2/app_crud/models/registrasi_api.dart';
import 'package:project_2/app_crud/pages/Api/endpoint/endpoint.dart';
import 'package:project_2/app_crud/preference/shared_preference.dart';

class AuthenticationAPI {
  // Ganti dengan URL API kamu

  /// ✅ Register User
  static Future<RegistrasiUserApi> registerUser({
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
      final registerUserModel = RegistrasiUserApi.fromJson(
        json.decode(response.body),
      );

      // SIMPAN TOKEN dan USER ID setelah register berhasil
      await PreferenceHandler.saveToken(registerUserModel.data.token);
      await PreferenceHandler.saveUserId(registerUserModel.data.user.id);
      return registerUserModel;
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  /// ✅ Login User
  static Future<RegistrasiUserApi> loginUser({
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
      final registerUserModel = RegistrasiUserApi.fromJson(
        json.decode(response.body),
      );

      await PreferenceHandler.saveToken(registerUserModel.data.token);
      await PreferenceHandler.saveUserId(registerUserModel.data.user.id);
      await PreferenceHandler.saveUserData(
        registerUserModel.data.user.name,
        registerUserModel.data.user.email,
      );
      await PreferenceHandler.saveLogin(true); // ✅ INI YANG PENTING

      return registerUserModel;
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Login gagal");
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

  static Future<SportCard> getFields() async {
    final url = Uri.parse(Endpoint.getFields);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return SportCard.fromJson(jsonDecode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal ambil data lapangan");
    }
  }

  /// ✅ Get Field Details by ID
  static Future<Datum> getFieldById(int fieldId) async {
    final url = Uri.parse('${Endpoint.getFields}/$fieldId');
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Datum.fromJson(responseData['data']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal ambil detail lapangan");
    }
  }

  /// ✅ Get Field Details by ID
}

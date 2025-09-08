import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project_2/app_crud/models/add_fileds.dart' hide Data;
import 'package:project_2/app_crud/models/gets_model.dart';

import 'package:project_2/app_crud/pages/Api/endpoint/endpoint.dart';
import 'package:project_2/app_crud/preference/shared_preference.dart';

class FieldService {
  /// CREATE Field
  static Future<AddFiled> createField({
    required String name,
    required int pricePerHour,
    required String imageBase64,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();
      final url = Uri.parse(Endpoint.getFields);

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "name": name,
          "price_per_hour": pricePerHour,
          "image_base64": imageBase64,
        }),
      );

      if (response.statusCode == 201) {
        return addFiledFromJson(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal menambahkan lapangan");
      }
    } catch (e) {
      print("Error createField: $e");
      rethrow;
    }
  }

  // GET, UPDATE, DELETE methods tetap sama seperti sebelumnya
  // ... (kode yang sudah ada)

  /// ✅ UPDATE Field dengan Base64 Image
  static Future<AddFiled> updateFieldWithImage({
    required int fieldId,
    required String name,
    required int pricePerHour,
    String? imageBase64,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();
      final url = Uri.parse(Endpoint.updateField(fieldId));

      Map<String, dynamic> requestData = {
        "name": name,
        "price_per_hour": pricePerHour,
      };

      if (imageBase64 != null && imageBase64.isNotEmpty) {
        requestData["image_base64"] = imageBase64;
      }

      final response = await http.put(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        return AddFiled.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal mengupdate lapangan");
      }
    } catch (e) {
      print("Error updateFieldWithImage: $e");
      rethrow;
    }
  }

  /// ✅ DELETE Field
  static Future<bool> deleteField(int fieldId) async {
    final url = Uri.parse(Endpoint.deleteField(fieldId));
    final token = await PreferenceHandler.getToken();

    final response = await http.delete(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception("Gagal menghapus field: ${response.body}");
    }
  }

  /// ✅ Get Jadwal Lapangan
}

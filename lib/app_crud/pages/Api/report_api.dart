import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:project_2/app_crud/models/add_fileds.dart';
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
}

// schedule_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project_2/app_crud/models/gets_model.dart';
import 'package:project_2/app_crud/models/model_jadwal.dart' hide Data;
import 'package:project_2/app_crud/pages/Api/endpoint/endpoint.dart';
import 'package:project_2/app_crud/preference/shared_preference.dart';

class ScheduleService {
  /// ✅ Add Schedule
  static Future<JadwalLapangan> addSchedule({
    required int fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();
      final url = Uri.parse(Endpoint.addSchedule);

      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "field_id": fieldId,
          "date": formattedDate,
          "start_time": startTime,
          "end_time": endTime,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return JadwalLapangan.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal menambahkan jadwal");
      }
    } catch (e) {
      print("Error addSchedule: $e");
      rethrow;
    }
  }

  // schedule_service.dart
  static Future<List<Data>> getSchedulesByField({
    required int fieldId,
    required DateTime date,
  }) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final token = await PreferenceHandler.getToken();
      // ✅ GUNAKAN ENDPOINT YANG BENAR
      final response = await http.get(
        Uri.parse(
          '${Endpoint.getSchedulesByField(fieldId)}?date=$formattedDate',
        ),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Debug response structure
        print('📦 Response: $responseData');
        print('🔑 Keys: ${responseData.keys}');

        // Handle response berdasarkan struktur yang diharapkan
        if (responseData is Map && responseData.containsKey('data')) {
          final jadwal = GetJadwal.fromJson(
            Map<String, dynamic>.from(responseData), // ✅ casting disini
          );
          return jadwal.data;
        } else {
          throw Exception("Format response tidak valid");
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal mengambil jadwal");
      }
    } catch (e) {
      print("❌ Error getSchedulesByField: $e");
      rethrow;
    }
  }

  /// ✅ Get Schedules by Field ID
  /// ✅ Get Schedules by Field ID
  /// ✅ Get Schedules by Field ID
}

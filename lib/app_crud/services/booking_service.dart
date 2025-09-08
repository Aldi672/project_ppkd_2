// booking_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_2/app_crud/models/booking_lapangan.dart';
import 'package:project_2/app_crud/pages/Api/endpoint/endpoint.dart';
import 'package:project_2/app_crud/preference/shared_preference.dart';

class BookingService {
  /// ✅ Book a schedule
  static Future<BookingLapangan> bookSchedule(int scheduleId) async {
    try {
      final token = await PreferenceHandler.getToken();
      final url = Uri.parse(Endpoint.bookField);

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({"schedule_id": scheduleId}),
      );

      print("Booking Response: ${response.statusCode}");
      print("Booking Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BookingLapangan.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal melakukan booking");
      }
    } catch (e) {
      print("Error bookSchedule: $e");
      rethrow;
    }
  }

  /// ✅ Get user bookings
  static Future<List<BookingLapangan>> getUserBookings() async {
    try {
      final token = await PreferenceHandler.getToken();
      final url = Uri.parse(Endpoint.getUserBookings);

      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Get Bookings Response: ${response.statusCode}");
      print("Get Bookings Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Handle berbagai format response
        if (responseData is Map && responseData.containsKey('data')) {
          if (responseData['data'] is List) {
            // Format: {"data": [{...}, {...}]}
            final bookings = responseData['data'] as List;
            return bookings
                .map(
                  (json) => BookingLapangan.fromJson({
                    "message": responseData["message"],
                    "data": json,
                  }),
                )
                .toList();
          } else if (responseData['data'] is Map) {
            // Format: {"data": {...}}
            return [
              BookingLapangan.fromJson(Map<String, dynamic>.from(responseData)),
            ];
          }
        } else if (responseData is List) {
          // Format: [{...}, {...}]
          return responseData
              .map((json) => BookingLapangan.fromJson(json))
              .toList();
        }

        throw Exception("Format response tidak valid");
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal mengambil data booking");
      }
    } catch (e) {
      print("Error getUserBookings: $e");
      rethrow;
    }
  }

  /// ✅ Cancel booking
  static Future<void> cancelBooking(int bookingId) async {
    try {
      final token = await PreferenceHandler.getToken();
      final url = Uri.parse(Endpoint.cancelBooking(bookingId));

      final response = await http.delete(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Cancel Booking Response: ${response.statusCode}");
      print("Cancel Booking Body: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 204) {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal membatalkan booking");
      }
    } catch (e) {
      print("Error cancelBooking: $e");
      rethrow;
    }
  }
}

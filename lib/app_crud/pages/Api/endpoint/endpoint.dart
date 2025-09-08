// endpoint.dart
class Endpoint {
  static const String baseURL = "https://appfutsal.mobileprojp.com/api";
  static const String register = "$baseURL/register";
  static const String profile = "$baseURL/profile";
  static const String login = "$baseURL/login";

  static const String addFields = "$baseURL/fields/";
  // Report endpoints
  static String get getFields => "$baseURL/fields";
  static String updateField(int id) => "$baseURL/fields/$id";
  static String deleteField(int id) => "$baseURL/fields/$id";

  static const String addSchedule = "$baseURL/schedules";

  // ✅ PERBAIKI: Endpoint untuk get schedules by field ID
  static String getSchedulesByField(int fieldId) {
    return "$baseURL/schedules/$fieldId"; // Pastikan endpoint ini benar
  }

  static const String bookField = "$baseURL/bookings"; // Untuk create booking
  static String getBookings = "$baseURL/bookings"; // Untuk get semua bookings
  static String getUserBookings =
      "$baseURL/user/bookings"; // Untuk get bookings user
  static String cancelBooking(int id) =>
      "$baseURL/bookings/$id"; // Untuk cancel booking
}

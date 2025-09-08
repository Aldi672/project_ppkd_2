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
    return "$baseURL/schedules/$fieldId"; //
  }

  static const String bookField = "$baseURL/bookings";
  static const String getUserBookings = "$baseURL/user/bookings";
}

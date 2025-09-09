import 'package:intl/intl.dart';

String formatRupiah(String price) {
  try {
    if (price.isEmpty) return "Rp 0";

    // parse string ke double
    double value = double.parse(price);
    // kalau mau dibulatkan ke integer
    int intValue = value.toInt();

    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(intValue);
  } catch (e) {
    return "Rp 0"; // fallback kalau parsing gagal
  }
}

// Fungsi untuk memformat waktu dengan menghilangkan detik
String formatTimeRange(String timeRange) {
  return timeRange.replaceAll(RegExp(r':00(?= - |$)'), '');
}

// Atau jika ingin lebih aman dengan parsing
String formatTimeRangeSafe(String timeRange) {
  try {
    final parts = timeRange.split(' - ');
    if (parts.length == 2) {
      final start = parts[0];
      final end = parts[1];

      // Hilangkan :00 dari akhir setiap waktu
      final formattedStart = start.replaceAll(RegExp(r':00$'), '');
      final formattedEnd = end.replaceAll(RegExp(r':00$'), '');

      return '$formattedStart - $formattedEnd';
    }
  } catch (e) {
    print('Error formatting time: $e');
  }
  return timeRange;
}

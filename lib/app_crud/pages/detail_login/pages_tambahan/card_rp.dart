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


// Atau jika ingin lebih aman dengan parsing


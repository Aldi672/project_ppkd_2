import 'package:intl/intl.dart';

String formatRupiah(String price) {
  try {
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
    return price; // fallback kalau parsing gagal
  }
}

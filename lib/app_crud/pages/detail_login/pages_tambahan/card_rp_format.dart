String formatTimeRangeSafe(String timeRange) {
  try {
    final parts = timeRange.split('-').map((e) => e.trim()).toList();
    if (parts.length == 2) {
      final start = parts[0];
      final end = parts[1];

      // Hilangkan ":00" hanya kalau ada di akhir
      final formattedStart = start.replaceAll(RegExp(r':00$'), '');
      final formattedEnd = end.replaceAll(RegExp(r':00$'), '');

      return '$formattedStart - $formattedEnd';
    }
  } catch (e) {
    print('Error formatting time: $e');
  }
  return timeRange;
}

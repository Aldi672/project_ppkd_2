import 'package:flutter/material.dart';
import 'package:project_2/app_crud/models/booking_lapangan.dart';
import 'package:project_2/app_crud/services/booking_service.dart';

class BookingHistoryPage extends StatefulWidget {
  static const String routeName = '/booking-history';

  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  late Future<List<BookingLapangan>> _bookingsFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _bookingsFuture = BookingService.getUserBookings();
      _isLoading = false;
    });
  }

  Future<void> _refreshBookings() async {
    setState(() {
      _bookingsFuture = BookingService.getUserBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Booking'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshBookings,
              child: FutureBuilder<List<BookingLapangan>>(
                future: _bookingsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada riwayat booking'),
                    );
                  } else {
                    final bookings = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        final schedule = booking.data?.schedule;
                        final field = schedule?.field;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            leading: field?.imageUrl != null
                                ? Image.network(
                                    field!.imageUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.sports_soccer, size: 40),
                            title: Text(field?.name ?? 'Lapangan'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal: ${schedule?.date}'),
                                Text(
                                  'Waktu: ${schedule?.startTime} - ${schedule?.endTime}',
                                ),
                                Text(
                                  'Status: ${booking.data?.schedule?.isBooked == "1" ? 'Terkonfirmasi' : 'Menunggu'}',
                                ),
                              ],
                            ),
                            trailing: booking.data?.schedule?.isBooked == "1"
                                ? null
                                : IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _cancelBooking(booking.data?.id);
                                    },
                                  ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
    );
  }

  Future<void> _cancelBooking(dynamic bookingId) async {
    if (bookingId == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Batalkan Booking'),
          content: const Text(
            'Apakah Anda yakin ingin membatalkan booking ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await BookingService.cancelBooking(bookingId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking berhasil dibatalkan'),
                    ),
                  );
                  _refreshBookings();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membatalkan: $e')),
                  );
                }
              },
              child: const Text('Ya', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

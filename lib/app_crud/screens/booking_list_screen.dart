// booking_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_2/app_crud/models/booking_lapangan.dart';
import 'package:project_2/app_crud/services/booking_service.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  late Future<List<BookingLapangan>> _bookingsFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _fetchBookings();
  }

  Future<List<BookingLapangan>> _fetchBookings() async {
    try {
      return await BookingService.getUserBookings();
    } catch (e) {
      throw Exception("Gagal memuat data booking: $e");
    }
  }

  void _refreshData() {
    setState(() {
      _bookingsFuture = _fetchBookings();
    });
  }

  Future<void> _cancelBooking(int bookingId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Batalkan Booking"),
        content: const Text("Apakah Anda yakin ingin membatalkan booking ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Ya, Batalkan"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await BookingService.cancelBooking(bookingId);
        _refreshData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Booking berhasil dibatalkan"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal membatalkan booking: $e"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildBookingItem(BookingLapangan booking) {
    final schedule = booking.data?.schedule;
    final field = schedule?.field;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.sports_soccer, color: Colors.green),
        title: Text(
          field?.name ?? "Lapangan",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jadwal: ${schedule?.startTime} - ${schedule?.endTime}"),
            Text(
              "Tanggal: ${schedule?.date != null ? DateFormat('d MMMM y').format(DateTime.parse(schedule!.date!)) : 'N/A'}",
            ),
            Text(
              "Status: Dikonfirmasi",
              style: TextStyle(color: Colors.green[700]),
            ),
          ],
        ),
        trailing: _isLoading
            ? const CircularProgressIndicator()
            : IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () => _cancelBooking(booking.data?.id ?? 0),
                tooltip: "Batalkan Booking",
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.book_online, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "Belum Ada Booking",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Anda belum melakukan booking lapangan",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _refreshData, child: const Text("Refresh")),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Memuat data booking..."),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            "Terjadi Kesalahan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshData,
            child: const Text("Coba Lagi"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Booking Saya"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
          ),
        ],
      ),
      body: FutureBuilder<List<BookingLapangan>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final booking = snapshot.data![index];
                return _buildBookingItem(booking);
              },
            );
          } else {
            return _buildEmptyState();
          }
        },
      ),
    );
  }
}

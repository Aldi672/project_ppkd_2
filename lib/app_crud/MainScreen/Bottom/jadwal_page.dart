import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_2/app_crud/models/booking_lapangan.dart';
import 'package:project_2/app_crud/models/gets_model.dart';
import 'package:project_2/app_crud/screens/add_schedule_screen.dart';
import 'package:project_2/app_crud/screens/booking_list_screen.dart';
import 'package:project_2/app_crud/services/booking_service.dart';
import 'package:project_2/app_crud/services/schedule_service.dart';

class JadwalScreen extends StatefulWidget {
  final int fieldId;
  final String fieldName;

  const JadwalScreen({
    super.key,
    required this.fieldId,
    required this.fieldName,
  });

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  late Future<List<Data>> _jadwalFuture;
  DateTime _selectedDate = DateTime.now();
  List<Data>? _cachedJadwalList; // Cache untuk data jadwal

  @override
  void initState() {
    super.initState();
    _jadwalFuture = _fetchJadwal();
  }

  Future<List<Data>> _fetchJadwal() async {
    try {
      final jadwalList = await ScheduleService.getSchedulesByField(
        fieldId: widget.fieldId,
        date: _selectedDate,
      );
      _cachedJadwalList = jadwalList; // Simpan data ke cache
      return jadwalList;
    } catch (e) {
      throw Exception("Gagal memuat jadwal: $e");
    }
  }

  void _refreshData() {
    setState(() {
      _jadwalFuture = _fetchJadwal();
    });
  }

  // ✅ Function untuk booking jadwal dengan optimistic update
  Future<void> _bookSchedule(int scheduleId, String timeRange) async {
    List<Data>? previousState;

    try {
      // Simpan state sebelumnya untuk fallback
      previousState = _cachedJadwalList;

      // Optimistic update - ubah status lokal menjadi booked
      if (_cachedJadwalList != null) {
        setState(() {
          _cachedJadwalList = _cachedJadwalList!.map((item) {
            if (item.id == scheduleId) {
              return Data(
                id: item.id,
                fieldId: item.fieldId,
                date: item.date,
                startTime: item.startTime,
                endTime: item.endTime,
                isBooked: "1", // Ubah status menjadi booked
                createdAt: item.createdAt,
                updatedAt: item.updatedAt,
              );
            }
            return item;
          }).toList();

          // Update future dengan data yang sudah diubah
          _jadwalFuture = Future.value(_cachedJadwalList!);
        });
      }

      final result = await BookingService.bookSchedule(scheduleId);

      // Refresh data setelah booking berhasil untuk sinkronisasi dengan server
      await Future.delayed(const Duration(milliseconds: 300));
      _refreshData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? "Booking berhasil!"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to booking details or show success dialog
      _showBookingSuccessDialog(result, timeRange);
    } catch (e) {
      // Rollback jika gagal
      if (previousState != null) {
        setState(() {
          _cachedJadwalList = previousState;
          _jadwalFuture = Future.value(previousState);
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal booking: $e"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // ✅ Dialog konfirmasi booking
  void _showBookingConfirmationDialog(int scheduleId, String timeRange) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Booking"),
        content: Text("Apakah Anda yakin ingin booking jadwal $timeRange?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _bookSchedule(scheduleId, timeRange);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Booking"),
          ),
        ],
      ),
    );
  }

  // ✅ Dialog sukses booking
  void _showBookingSuccessDialog(BookingLapangan booking, String timeRange) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Booking Berhasil!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jadwal: $timeRange"),
            Text("Lapangan: ${widget.fieldName}"),
            Text("Tanggal: ${DateFormat('d MMMM y').format(_selectedDate)}"),
            const SizedBox(height: 16),
            const Text(
              "Booking ID:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("#${booking.data?.id ?? 'N/A'}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to booking list screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingListScreen(),
                ),
              );
            },
            child: const Text("Lihat Booking Saya"),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _cachedJadwalList = null; // Reset cache saat ganti tanggal
        _refreshData();
      });
    }
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.green[700],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.fieldName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, d MMMM y').format(_selectedDate),
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('d MMMM y').format(_selectedDate),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          IconButton(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today, color: Colors.green),
            tooltip: "Pilih Tanggal",
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalItem(Data jadwal) {
    final isBooked = jadwal.isBooked == "1";
    final timeRange = "${jadwal.startTime} - ${jadwal.endTime}";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBooked ? Colors.red[100]! : Colors.green[100]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan logo dan nama venue
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.safety_divider_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.fieldName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  Container(height: 1, color: Colors.grey[300]),
                  const SizedBox(height: 16),

                  // Detail lapangan
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Lapangan 2',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tanggal dan waktu
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${jadwal.startTime} - ${jadwal.endTime}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Text(
                    isBooked ? "Sudah Dipesan" : "Tersedia",
                    style: TextStyle(
                      color: isBooked ? Colors.red[600] : Colors.green[600],
                    ),
                  ),

                  // Status booking
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green),
                          ),
                          child: const Text(
                            'Dikonfirmasi',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      if (!isBooked)
                        IconButton(
                          icon: const Icon(
                            Icons.book_online,
                            color: Colors.blue,
                          ),
                          onPressed: () => _showBookingConfirmationDialog(
                            jadwal.id!,
                            timeRange,
                          ),
                          tooltip: "Booking Jadwal",
                        ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isBooked ? Colors.red : Colors.green,
                        ),
                        child: Icon(
                          isBooked ? Icons.check : Icons.circle,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Text(
          //   "${jadwal.startTime} - ${jadwal.endTime}",
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold,
          //     color: isBooked ? Colors.red[800] : Colors.green[800],
          //   ),
          // ),
          // const SizedBox(height: 4),
          // Text(
          //   isBooked ? "Sudah Dipesan" : "Tersedia",
          //   style: TextStyle(
          //     color: isBooked ? Colors.red[600] : Colors.green[600],
          //   ),
          // ),
          // if (jadwal.date != null) ...[
          //   const SizedBox(height: 4),
          //   Text(
          //     DateFormat('d MMMM y').format(jadwal.date!),
          //     style: const TextStyle(fontSize: 12, color: Colors.grey),
          //   ),
          // ],
        ],
      ),
    );
  }

  Widget _buildJadwalList(List<Data> jadwalList) {
    jadwalList.sort((a, b) => a.startTime!.compareTo(b.startTime!));

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: jadwalList.length,
        itemBuilder: (context, index) {
          final jadwal = jadwalList[index];
          return _buildJadwalItem(jadwal);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.schedule, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "Belum ada jadwal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Untuk tanggal ${DateFormat('d MMMM y').format(_selectedDate)}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
              child: const Text("Refresh Jadwal"),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddScheduleScreen(
                      fieldId: widget.fieldId,
                      fieldName: widget.fieldName,
                    ),
                  ),
                ).then((value) {
                  if (value == true) {
                    _refreshData();
                  }
                });
              },
              child: const Text("Tambah Jadwal Pertama"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Expanded(
      child: Center(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Memuat jadwal..."),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jadwal ${widget.fieldName}"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScheduleScreen(
                fieldId: widget.fieldId,
                fieldName: widget.fieldName,
              ),
            ),
          ).then((value) {
            if (value == true) {
              _refreshData();
            }
          });
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildDateSelector(),
          const SizedBox(height: 8),
          FutureBuilder<List<Data>>(
            future: _jadwalFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              } else if (snapshot.hasError) {
                return _buildErrorState(snapshot.error.toString());
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return _buildJadwalList(snapshot.data!);
              } else {
                return _buildEmptyState();
              }
            },
          ),
        ],
      ),
    );
  }
}

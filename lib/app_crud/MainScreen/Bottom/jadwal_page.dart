import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_2/app_crud/models/gets_model.dart';

import 'package:project_2/app_crud/pages/Api/scheduleservice.dart';
import 'package:project_2/app_crud/screens/add_schedule_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _jadwalFuture = _fetchJadwal();
  }

  Future<List<Data>> _fetchJadwal() async {
    try {
      return await ScheduleService.getSchedulesByField(
        fieldId: widget.fieldId,
        date: _selectedDate,
      );
    } catch (e) {
      throw Exception("Gagal memuat jadwal: $e");
    }
  }

  void _refreshData() {
    setState(() {
      _jadwalFuture = _fetchJadwal();
    });
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
        _refreshData();
      });
    }
  }

  Future<void> _deleteSchedule(int scheduleId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Jadwal"),
        content: const Text("Apakah Anda yakin ingin menghapus jadwal ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
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
    final isBooked =
        jadwal.isBooked == "1"; // Perhatikan: isBooked adalah String

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
      child: Row(
        children: [
          // Time and status section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${jadwal.startTime} - ${jadwal.endTime}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isBooked ? Colors.red[800] : Colors.green[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isBooked ? "Sudah Dipesan" : "Tersedia",
                  style: TextStyle(
                    color: isBooked ? Colors.red[600] : Colors.green[600],
                  ),
                ),
                if (jadwal.date != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d MMMM y').format(jadwal.date!),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),

          // Status icon and delete button
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isBooked)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteSchedule(jadwal.id!),
                  tooltip: "Hapus Jadwal",
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
    );
  }

  Widget _buildJadwalList(List<Data> jadwalList) {
    // Sort jadwal by start time
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
      // FLOATING ACTION BUTTON DIHAPUS DARI SINI
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

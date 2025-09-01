import 'package:flutter/material.dart';
import 'package:project_2/app_crud/db/db_helper.dart';
import 'package:project_2/app_crud/pages/login-register_api/login_user.dart';

import 'package:project_2/app_crud/services/auth_prefs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = '';
  String _email = '';
  int _totalBooks = 0;
  int _completedBooks = 0;
  int _currentlyReading = 0;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadBookStatistics();
  }

  Future<void> _loadUserData() async {
    try {
      final username = await AuthPreferences.getUsername();
      final email = await AuthPreferences.getEmail();
      setState(() {
        _username = username;
        _email = email;
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _loadBookStatistics() async {
    try {
      final total = await DatabaseHelper.instance.getTotalBooks();
      final completed = await DatabaseHelper.instance.getCompletedBooks();
      final reading = await DatabaseHelper.instance.getCurrentlyReading();
      setState(() {
        _totalBooks = total;
        _completedBooks = completed;
        _currentlyReading = reading;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading statistics: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await AuthPreferences.logout();
        if (mounted) {
          // Navigate to login screen and remove all previous routes
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const UserLogin()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saat logout: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildStatisticCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color? iconColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.deepPurple),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: iconColor ?? Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade400,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Profile Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.deepPurple.shade400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Username
                        Text(
                          _username.isNotEmpty ? _username : 'User',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Email
                        Text(
                          _email.isNotEmpty ? _email : 'user@example.com',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Statistics Section
                  const Text(
                    'Statistik Membaca',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Statistics Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildStatisticCard(
                        'Total Buku',
                        _totalBooks.toString(),
                        Icons.library_books,
                        Colors.blue,
                      ),
                      _buildStatisticCard(
                        'Sedang Dibaca',
                        _currentlyReading.toString(),
                        Icons.book_online,
                        Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildStatisticCard(
                        'Buku Selesai',
                        _completedBooks.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildStatisticCard(
                        'Belum Dibaca',
                        (_totalBooks - _completedBooks - _currentlyReading)
                            .toString(),
                        Icons.schedule,
                        Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Menu Section
                  const Text(
                    'Pengaturan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Menu Items
                  _buildMenuTile('Informasi Aplikasi', Icons.info_outline, () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Informasi Aplikasi'),
                        content: const Text(
                          'Manajemen Buku Pribadi v1.0\n\n'
                          'Aplikasi untuk mengelola koleksi buku pribadi Anda. '
                          'Anda dapat menambah, mengedit, dan melacak progress membaca buku.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }),
                  _buildMenuTile('Bantuan', Icons.help_outline, () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Bantuan'),
                        content: const Text(
                          'Cara menggunakan aplikasi:\n\n'
                          '1. Tambah buku dengan menekan tombol + di halaman utama\n'
                          '2. Tap buku untuk melihat detail dan mengupdate progress\n'
                          '3. Gunakan filter untuk melihat buku berdasarkan status\n'
                          '4. Gunakan pencarian untuk menemukan buku tertentu',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

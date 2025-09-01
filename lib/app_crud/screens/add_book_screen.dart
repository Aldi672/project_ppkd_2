import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_2/app_crud/db/db_helper.dart';
import 'package:project_2/app_crud/models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});
  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      //menunggu sampai user memilih atau membatalkan.
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _totalPagesController = TextEditingController();
  final _currentPageController = TextEditingController();
  String _selectedGenre = 'Fiksi';
  String _selectedStatus = 'to_read';
  bool _isLoading =
      false; // dipakai untuk men-disable tombol dan menampilkan spinner
  final List<String> _genres = [
    'Fiksi',
    'Non-Fiksi',
    'Romance',
    'Mystery',
    'Fantasy',
    'Sci-Fi',
    'Biography',
    'History',
    'Self-Help',
    'Educational',
    'Comic',
    'Poetry',
    'Other',
  ];
  final List<Map<String, String>> _statusOptions = [
    {'value': 'to_read', 'label': 'Belum Dibaca'},
    {'value': 'reading', 'label': 'Sedang Dibaca'},
    {'value': 'completed', 'label': 'Selesai'},
  ];
  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _totalPagesController.dispose();
    _currentPageController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    // Fungsi async untuk menyimpan data buku ke database

    if (!_formKey.currentState!.validate()) return;
    // Validasi form, kalau form tidak valid langsung keluar (return) dan tidak lanjut

    setState(() {
      _isLoading = true;
    });
    // Ubah state menjadi loading (misalnya untuk menampilkan indikator loading)

    try {
      final book = Book(
        // Membuat objek Book baru dari input user
        title: _titleController.text.trim(),
        // Ambil teks judul dari controller dan hapus spasi depan-belakang
        author: _authorController.text.trim(),
        // Ambil nama penulis
        description: _descriptionController.text.trim(),
        // Ambil deskripsi
        genre: _selectedGenre,
        // Ambil genre yang dipilih user
        totalPages: int.parse(_totalPagesController.text),
        // Ambil total halaman, diubah ke integer
        currentPage: int.parse(
          _currentPageController.text.isEmpty
              ? '0'
              : _currentPageController.text,
        ),
        // Ambil halaman yang sedang dibaca, kalau kosong otomatis jadi 0
        status: _selectedStatus,
        // Ambil status buku (misalnya "reading" atau "completed")
        dateAdded: DateTime.now(),
        // Simpan tanggal saat buku ditambahkan
        dateCompleted: _selectedStatus == 'completed' ? DateTime.now() : null,
        // Kalau status completed, simpan juga tanggal selesai, kalau belum biarkan null
        imagePath: _image?.path,
        // Simpan path gambar kalau ada
      );

      await DatabaseHelper.instance.createBook(book);
      // Simpan buku ke database menggunakan DatabaseHelper

      if (mounted) {
        // Pastikan widget masih ada di tree (tidak dispose)

        setState(() {
          _image = null;
        });
        // Reset gambar setelah berhasil menyimpan buku

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil ditambahkan'),
            backgroundColor: Colors.deepPurple,
          ),
        );
        // Tampilkan notifikasi snackbar kalau buku berhasil ditambahkan

        Navigator.pop(context, true);
        // Kembali ke halaman sebelumnya, sekaligus mengirim hasil "true"
        // (biasanya digunakan untuk memicu refresh data di halaman sebelumnya)
      }
    } catch (e) {
      // Tangkap error jika ada kesalahan saat menyimpan buku

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error menambah buku: $e'),
            backgroundColor: Colors.red,
          ),
        );
        // Tampilkan pesan error lewat snackbar
      }
    } finally {
      // Bagian ini tetap jalan meskipun ada error

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Ubah status loading jadi false agar indikator loading hilang
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Buku'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveBook,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Book Cover Preview
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.shade200),
              ),

              child: _image != null
                  ? GestureDetector(
                      onTap: _pickImage,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
                    )
                  : GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.add_a_photo),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Buku *',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Judul buku tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Current Page Field (only show if reading)
            if (_selectedStatus == 'reading') ...[
              TextFormField(
                controller: _currentPageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Halaman Saat Ini',
                  prefixIcon: Icon(Icons.bookmark_outline),
                  hintText: '0',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final currentPage = int.tryParse(value);
                    final totalPages = int.tryParse(_totalPagesController.text);
                    if (currentPage == null || currentPage < 0) {
                      return 'Halaman saat ini harus berupa angka positif';
                    }
                    if (totalPages != null && currentPage > totalPages) {
                      return 'Halaman saat ini tidak boleh melebihi total halaman';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
            // Description Field
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Deskripsi tidak boleh kosong';
                }
                return null;
              },
            ),

            // Save Button

            // Author Field
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Penulis *',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Penulis tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Genre Dropdown
            DropdownButtonFormField<String>(
              value: _selectedGenre,
              decoration: const InputDecoration(
                labelText: 'Genre',
                prefixIcon: Icon(Icons.category),
              ),
              items: _genres.map((genre) {
                return DropdownMenuItem(value: genre, child: Text(genre));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            // Total Pages Field
            TextFormField(
              controller: _totalPagesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Halaman *',
                prefixIcon: Icon(Icons.pages),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Total halaman tidak boleh kosong';
                }
                final pages = int.tryParse(value);
                if (pages == null || pages <= 0) {
                  return 'Total halaman harus berupa angka positif';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Status Dropdown
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status Baca',
                prefixIcon: Icon(Icons.bookmark),
              ),
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status['value'],
                  child: Text(status['label']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveBook,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Buku', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

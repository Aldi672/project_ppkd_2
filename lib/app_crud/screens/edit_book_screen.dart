// ignore_for_file: unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_2/app_crud/db/db_helper.dart';
import 'package:project_2/app_crud/models/book.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;
  const EditBookScreen({super.key, required this.book});
  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionController;
  late TextEditingController _totalPagesController;
  late TextEditingController _currentPageController;
  late String _selectedGenre;
  late String _selectedStatus;
  bool _isLoading = false;
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
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _descriptionController = TextEditingController(
      text: widget.book.description,
    );
    _totalPagesController = TextEditingController(
      text: widget.book.totalPages.toString(),
    );
    _currentPageController = TextEditingController(
      text: widget.book.currentPage.toString(),
    );
    _selectedGenre = widget.book.genre;
    _selectedStatus = widget.book.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _totalPagesController.dispose();
    _currentPageController.dispose();
    super.dispose();
  }

  Future<void> _updateBook() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      DateTime? completedDate = widget.book.dateCompleted;
      // Update completed date based on status changes
      if (_selectedStatus == 'completed' && widget.book.status != 'completed') {
        completedDate = DateTime.now();
      } else if (_selectedStatus != 'completed') {
        completedDate = null;
      }
      // Auto-update current page if status is completed
      int currentPage = int.parse(
        _currentPageController.text.isEmpty ? '0' : _currentPageController.text,
      );
      // otomatis currentPage akan sama dengan jumlah total halaman
      if (_selectedStatus == 'completed') {
        currentPage = int.parse(_totalPagesController.text);
      }
      // Buat objek buku baru berdasarkan data lama
      final updatedBook = widget.book.copyWith(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
        genre: _selectedGenre,
        totalPages: int.parse(_totalPagesController.text),
        currentPage: currentPage,
        status: _selectedStatus,
        dateCompleted: completedDate,
        imagePath: _image != null ? _image!.path : widget.book.imagePath,
      );
      await DatabaseHelper.instance.updateBook(updatedBook);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil diperbarui'),
            backgroundColor: Colors.deepPurple,
          ),
        );
        Navigator.pop(context, updatedBook);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error memperbarui buku: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Buku'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _updateBook,
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            // Book Cover Preview
            GestureDetector(
              onTap: () {
                _pickImage(); // <-- fungsi untuk ambil / ganti foto
              },
              child: Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                      : widget.book.coverImagePath != null
                      ? DecorationImage(
                          image: FileImage(File(widget.book.coverImagePath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 48, color: Colors.white),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),
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
            // Author Field
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
                  // Reset current page if status changed to 'to_read'
                  if (_selectedStatus == 'to_read') {
                    _currentPageController.text = '0';
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            // Current Page Field (show for reading and completed)
            if (_selectedStatus == 'reading' ||
                _selectedStatus == 'completed') ...[
              TextFormField(
                controller: _currentPageController,
                keyboardType: TextInputType.number,
                enabled: _selectedStatus != 'completed', // Disable if completed
                decoration: InputDecoration(
                  labelText: _selectedStatus == 'completed'
                      ? 'Halaman Selesai'
                      : 'Halaman Saat Ini',
                  prefixIcon: const Icon(Icons.bookmark_outline),
                  hintText: '0',
                  helperText: _selectedStatus == 'completed'
                      ? 'Otomatis diisi sesuai total halaman'
                      : null,
                ),
                validator: (value) {
                  if (_selectedStatus == 'reading') {
                    if (value != null && value.isNotEmpty) {
                      final currentPage = int.tryParse(value);
                      final totalPages = int.tryParse(
                        _totalPagesController.text,
                      );
                      if (currentPage == null || currentPage < 0) {
                        return 'Halaman saat ini harus berupa angka positif';
                      }
                      if (totalPages != null && currentPage > totalPages) {
                        return 'Halaman saat ini tidak boleh melebihi total halaman';
                      }
                    }
                  }
                  return null;
                },
                onChanged: (value) {
                  // Auto-update to completed if current page equals total pages
                  if (_selectedStatus == 'reading') {
                    final currentPage = int.tryParse(value);
                    final totalPages = int.tryParse(_totalPagesController.text);
                    if (currentPage != null &&
                        totalPages != null &&
                        currentPage >= totalPages) {
                      setState(() {
                        _selectedStatus = 'completed';
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
            // Progress indicator for reading status
            if (_selectedStatus == 'reading') ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress Membaca',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        final currentPage =
                            int.tryParse(_currentPageController.text) ?? 0;
                        final totalPages =
                            int.tryParse(_totalPagesController.text) ?? 1;
                        final progress = totalPages > 0
                            ? currentPage / totalPages
                            : 0.0;
                        return Column(
                          children: [
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.deepPurple.shade400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$currentPage/$totalPages halaman (${(progress * 100).toInt()}%)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
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
            const SizedBox(height: 32),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateBook,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Perbarui Buku',
                        style: TextStyle(fontSize: 16),
                      ),
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

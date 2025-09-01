import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_2/app_crud/db/db_helper.dart';
import 'package:project_2/app_crud/models/book.dart';
import 'package:project_2/app_crud/screens/add_book_screen.dart';
import 'package:project_2/app_crud/screens/book_detail_screen.dart';
import 'package:project_2/app_crud/screens/profile_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});
  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final books = await DatabaseHelper.instance.readAllBooks();
      setState(() {
        _books = books;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading books: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _applyFilter() {
    List<Book> filtered = _books;
    // Apply status filter
    switch (_selectedFilter) {
      case 'reading':
        filtered = _books.where((book) => book.status == 'reading').toList();
        break;
      case 'completed':
        filtered = _books.where((book) => book.status == 'completed').toList();
        break;
      case 'to_read':
        filtered = _books.where((book) => book.status == 'to_read').toList();
        break;
      default:
        filtered = _books;
    }
    // Apply search filter
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((book) {
        return book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query) ||
            book.genre.toLowerCase().contains(query);
      }).toList();
    }
    setState(() {
      _filteredBooks = filtered;
    });
  }

  Future<void> _deleteBook(Book book) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Buku'),
        content: Text('Apakah Anda yakin ingin menghapus "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true && book.id != null) {
      try {
        await DatabaseHelper.instance.deleteBook(book.id!);
        _loadBooks();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting book: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildStatistics() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(
            'Total',
            _books.length.toString(),
            Icons.library_books,
          ),
          _buildStatCard(
            'Dibaca',
            _books.where((b) => b.status == 'reading').length.toString(),
            Icons.book_online,
          ),
          _buildStatCard(
            'Selesai',
            _books.where((b) => b.status == 'completed').length.toString(),
            Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('all', 'Semua'),
                _buildFilterChip('reading', 'Sedang Dibaca'),
                _buildFilterChip('completed', 'Selesai'),
                _buildFilterChip('to_read', 'Belum Dibaca'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected:
            isSelected, // menentukan apakah chip ini sedang terpilih atau tidak
        label: Text(
          label,
        ), // teks yang tampil di chip (misalnya "Semua", "Selesai", "Belum")
        onSelected: (selected) {
          // callback saat chip diklik / dipilih
          setState(() {
            _selectedFilter =
                value; // simpan nilai filter yang dipilih ke variabel state
            _applyFilter(); // panggil fungsi untuk menerapkan filter pada daftar buku
          });
        },
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () async {
          final updatedBook = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(book: book),
            ),
          );

          if (updatedBook != null) {
            // Cek dulu apakah data updatedBook tidak null (ada buku yang berhasil diupdate)

            final index = _books.indexWhere((b) => b.id == updatedBook.id);
            // Cari posisi (index) buku yang ada di list _books dengan mencocokkan id buku
            // indexWhere akan mengembalikan posisi pertama yang cocok, atau -1 jika tidak ada

            if (index != -1) {
              // Kalau index tidak -1 berarti buku dengan id yang sama ditemukan di dalam list

              setState(() {
                _books[index] = updatedBook;
                // Update data buku di posisi tersebut dengan data buku yang sudah diperbarui
                // setState dipanggil agar UI di-refresh sesuai data terbaru
              });
            }
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Book Cover Placeholder
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: book.imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(book.imagePath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.book,
                        size: 40,
                        color: Colors.deepPurple,
                      ),
              ),

              const SizedBox(width: 16),
              // Book Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'oleh ${book.author}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: book.statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            book.statusText,
                            style: TextStyle(
                              fontSize: 12,
                              color: book.statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          book.genre,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    if (book.status == 'reading') ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: book.progress,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple.shade400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${book.currentPage}/${book.totalPages} halaman',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Action Button
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'delete':
                      _deleteBook(book);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksi Buku'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              if (result == 'logout') {
                // Handle logout from profile screen
              }
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics
          _buildStatistics(),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _applyFilter(),
              decoration: InputDecoration(
                hintText: 'Cari buku, penulis, atau genre...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _applyFilter();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
          ),
          // Filter Chips
          _buildFilterChips(),
          // Book List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredBooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.library_books_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _books.isEmpty
                              ? 'Belum ada buku dalam koleksi'
                              : 'Tidak ada buku yang sesuai filter',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (_books.isEmpty) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddBookScreen(),
                                ),
                              );
                              if (result == true) {
                                _loadBooks();
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Tambah Buku Pertama'),
                          ),
                        ],
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadBooks,
                    child: ListView.builder(
                      itemCount: _filteredBooks.length,
                      itemBuilder: (context, index) {
                        return _buildBookCard(_filteredBooks[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookScreen()),
          );
          if (result == true) {
            _loadBooks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

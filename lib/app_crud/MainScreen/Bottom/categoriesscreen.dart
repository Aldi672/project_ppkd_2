import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_2/app_crud/db/db_helper.dart';
import 'package:project_2/app_crud/models/book.dart';
import 'package:project_2/app_crud/screens/book_reading.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = true;

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Langsung load data tanpa menunggu refresh indicator
    _loadBooks();

    // Opsional: tetap sediakan refresh indicator untuk manual refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshKey.currentState?.show();
    });
  }

  Future<void> _refreshBooks() async {
    await _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final books = await DatabaseHelper.instance.readAllBooks();
      setState(() {
        _books = books;
        _filteredBooks = books; // default semua tampil
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error load books: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
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
                        : 'Tidak ada buku sesuai filter',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              key: _refreshKey,
              onRefresh: _loadBooks,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: _filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = _filteredBooks[index];
                  return _buildBookGridCard(context, book);
                },
              ),
            ),
    );
  }

  Widget _buildBookGridCard(BuildContext context, Book book) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BacaAsbabunNuzulScreen()),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.deepPurple.shade50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cover Buku
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: book.imagePath != null
                      ? Image.file(
                          File(book.imagePath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Container(
                          color: Colors.deepPurple.shade100,
                          child: const Icon(
                            Icons.book,
                            size: 40,
                            color: Colors.deepPurple,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 6),
              // Judul Buku
              Text(
                book.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              // Genre
              Text(
                book.genre,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

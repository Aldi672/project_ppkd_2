// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:project_2/app_crud/db/db_helper.dart';
// import 'package:project_2/app_crud/models/book.dart';
// import 'package:project_2/app_crud/screens/edit_book_screen.dart';

// class BookDetailScreen extends StatefulWidget {
//   final Book book;
//   const BookDetailScreen({super.key, required this.book});
//   @override
//   State<BookDetailScreen> createState() => _BookDetailScreenState();
// }

// class _BookDetailScreenState extends State<BookDetailScreen> {
//   late Book _book;
//   bool _isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     _book = widget.book;
//   }

//   Future<void> _updateProgress() async {
//     final currentPageController = TextEditingController(
//       text: _book.currentPage.toString(),
//     );
//     final newPage = await showDialog<int>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Update Progress'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Total halaman: ${_book.totalPages}',
//               style: TextStyle(color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: currentPageController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Halaman saat ini',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Batal'),
//           ),
//           TextButton(
//             onPressed: () {
//               final page = int.tryParse(currentPageController.text);
//               if (page != null && page >= 0 && page <= _book.totalPages) {
//                 Navigator.pop(context, page);
//               }
//             },
//             child: const Text('Simpan'),
//           ),
//         ],
//       ),
//     );
//     if (newPage != null) {
//       setState(() {
//         _isLoading = true;
//       });
//       try {
//         String newStatus = _book.status;
//         DateTime? completedDate = _book.dateCompleted;
//         if (newPage == _book.totalPages && _book.status != 'completed') {
//           newStatus = 'completed';
//           completedDate = DateTime.now();
//         } else if (newPage > 0 && newPage < _book.totalPages) {
//           newStatus = 'reading';
//           completedDate = null;
//         }
//         final updatedBook = _book.copyWith(
//           currentPage: newPage,
//           status: newStatus,
//           dateCompleted: completedDate,
//         );
//         await DatabaseHelper.instance.updateBook(updatedBook);
//         setState(() {
//           _book = updatedBook;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Progress berhasil diupdate'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error updating progress: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _deleteBook() async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Hapus Buku'),
//         content: Text('Apakah Anda yakin ingin menghapus "${_book.title}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Batal'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Hapus'),
//           ),
//         ],
//       ),
//     );
//     if (confirm == true && _book.id != null) {
//       setState(() {
//         _isLoading = true;
//       });
//       try {
//         await DatabaseHelper.instance.deleteBook(_book.id!);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Buku berhasil dihapus'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context, true);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error deleting book: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Widget _buildInfoCard(String title, String value, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.deepPurple, size: 24),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pop(context, _book);
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Detail Buku'),
//           actions: [
//             IconButton(
//               onPressed: _isLoading
//                   ? null
//                   : () async {
//                       final result = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditBookScreen(book: _book),
//                         ),
//                       );
//                       if (result is Book) {
//                         setState(() {
//                           _book = result;
//                         });
//                       }
//                     },
//               icon: const Icon(Icons.edit),
//             ),
//             PopupMenuButton<String>(
//               onSelected: (value) {
//                 switch (value) {
//                   case 'delete':
//                     _deleteBook();
//                     break;
//                 }
//               },
//               itemBuilder: (context) => [
//                 const PopupMenuItem(
//                   value: 'delete',
//                   child: Row(
//                     children: [
//                       Icon(Icons.delete, color: Colors.red),
//                       SizedBox(width: 8),
//                       Text('Hapus'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         body: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header with book cover and title
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(24),

//                       decoration: BoxDecoration(
//                         image: _book.imagePath != null
//                             ? DecorationImage(
//                                 image: FileImage(File(_book.imagePath!)),
//                                 fit: BoxFit.cover,
//                               )
//                             : null,
//                       ),
//                       child: Column(
//                         children: [
//                           // Book Cover
//                           SizedBox(height: 20),
//                           Container(
//                             width: 120,
//                             height: 160,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.2),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 5),
//                                 ),
//                               ],
//                             ),
//                             child: _book.imagePath != null
//                                 ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Image.file(
//                                       File(_book.imagePath!),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   )
//                                 : Icon(
//                                     Icons.book,
//                                     size: 60,
//                                     color: Colors.deepPurple.shade400,
//                                   ),
//                           ),
//                           const SizedBox(height: 16),
//                           // Title
//                           Text(
//                             _book.title,
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 8),
//                           // Author
//                           Text(
//                             'oleh ${_book.author}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.white70,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 16),
//                           // Status Badge
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _book.statusColor,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               _book.statusText,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     // hanya akan ditampilkan jika status buku adalah (sedang dibaca).
//                     if (_book.status == 'reading') ...[
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 24),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'Progress Membaca',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 TextButton.icon(
//                                   onPressed:
//                                       _updateProgress, // Saat tombol ditekan → fungsi _updateProgress dipanggil
//                                   icon: const Icon(Icons.edit),
//                                   label: const Text('Update'),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             LinearProgressIndicator(
//                               value: _book
//                                   .progress, // nilai presentase antara 0.0 sampai 1.0
//                               backgroundColor: Colors.grey.shade300,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.deepPurple.shade400,
//                               ),
//                               minHeight: 8,
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               '${_book.currentPage}/${_book.totalPages} halaman (${(_book.progress * 100).toInt()}%)', //halaman sekarang. //jumlah total halaman. //persen progress
//                               style: TextStyle(
//                                 color: Colors.grey.shade600,
//                               ), // Misalnya kalau buku 200 halaman dan sekarang di halaman 50 → 50/200 halaman (25%).
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                     ],
//                     // Book Information
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Informasi Buku',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   // aksi saat tombol ditekan
//                                 },
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 8,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.green.shade400,
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Text(
//                                     _book.statusText.toLowerCase() ==
//                                             'selesai' // huruf kapital/kecil tidak masalah.
//                                         ? 'Baca Ulang'
//                                         : _book.statusText.toLowerCase() ==
//                                               'belum dibaca'
//                                         ? 'Lanjut Baca'
//                                         : 'Baca Sekarang',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 16),
//                           // Info Cards Grid
//                           GridView.count(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             crossAxisCount: 2,
//                             mainAxisSpacing: 12,
//                             crossAxisSpacing: 12,
//                             childAspectRatio: 2.5,
//                             children: [
//                               // Info Genre buku
//                               _buildInfoCard(
//                                 'Genre',
//                                 _book.genre, // Isi: genre buku
//                                 Icons.category,
//                               ),
//                               // Info jumlah halaman total buku
//                               _buildInfoCard(
//                                 'Total Halaman',
//                                 '${_book.totalPages}', // Isi: total halaman
//                                 Icons.pages,
//                               ),
//                               // Info kapan buku ditambahkan ke koleksi
//                               _buildInfoCard(
//                                 'Tanggal Ditambah',
//                                 '${_book.dateAdded.day}/${_book.dateAdded.month}/${_book.dateAdded.year}', // Format tanggal sederhana:
//                                 Icons.calendar_today,
//                               ),
//                               // Info kapan buku selesai dibaca (opsional, hanya jika tidak null)
//                               if (_book.dateCompleted != null)
//                                 _buildInfoCard(
//                                   'Tanggal Selesai',
//                                   '${_book.dateCompleted!.day}/${_book.dateCompleted!.month}/${_book.dateCompleted!.year}', // Tanggal selesai dalam format
//                                   Icons.check_circle,
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 24),
//                           // Description
//                           const Text(
//                             'Deskripsi',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade50,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.grey.shade200),
//                             ),
//                             child: Text(
//                               _book
//                                       .description
//                                       .isNotEmpty // tampilkan teks default
//                                   ? _book.description
//                                   : 'Tidak ada deskripsi',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: _book.description.isNotEmpty
//                                     ? Colors.black87
//                                     : Colors.grey.shade500,
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//         // Floating Action Button for quick actions
//         // Jika buku sedang dalam status dibaca, tombol "Update Progress" muncul di bawah kanan.
//         floatingActionButton: _book.status == 'reading'
//             ? FloatingActionButton.extended(
//                 onPressed: _updateProgress,
//                 icon: const Icon(Icons.bookmark_add),
//                 label: const Text('Update Progress'),
//               )
//             : null,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:project_2/app_crud/MainScreen/Bottom/jadwal_page.dart';
// import 'package:project_2/app_crud/models/card_user.dart';
// import 'package:project_2/app_crud/pages/Api/authentication.dart';
// // import 'package:project_2/app_crud/screens/jadwal_screen.dart';

// class JadwalListScreen extends StatefulWidget {
//   const JadwalListScreen({super.key});

//   @override
//   State<JadwalListScreen> createState() => _JadwalListScreenState();
// }

// class _JadwalListScreenState extends State<JadwalListScreen> {
//   late Future<SportCard> _fieldsFuture;
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _fieldsFuture = _fetchFields();
//   }

//   Future<SportCard> _fetchFields() async {
//     try {
//       return await AuthenticationAPI.getFields();
//     } catch (e) {
//       throw Exception("Gagal memuat data lapangan: $e");
//     }
//   }

//   void _refreshData() {
//     setState(() {
//       _fieldsFuture = _fetchFields();
//     });
//   }

//   void _navigateToJadwalScreen(int fieldId, String fieldName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             JadwalScreen(fieldId: fieldId, fieldName: fieldName),
//       ),
//     );
//   }

//   Widget _buildFieldCard(Datum field) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       child: ListTile(
//         leading: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             image: DecorationImage(
//               image: NetworkImage(field.imageUrl),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         title: Text(
//           field.name,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           "${formatRupiah(field.pricePerHour)}/jam",
//           style: const TextStyle(color: Colors.green),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: () => _navigateToJadwalScreen(field.id, field.name),
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return const Center(child: CircularProgressIndicator());
//   }

//   Widget _buildErrorState(String error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 64, color: Colors.red),
//           const SizedBox(height: 16),
//           Text("Error: $error", textAlign: TextAlign.center),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: _refreshData,
//             child: const Text("Coba Lagi"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.sports_soccer, size: 64, color: Colors.grey),
//           SizedBox(height: 16),
//           Text("Tidak ada data lapangan"),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Daftar Lapangan"),
//         backgroundColor: Colors.green[700],
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(onPressed: _refreshData, icon: const Icon(Icons.refresh)),
//         ],
//       ),
//       body: FutureBuilder<SportCard>(
//         future: _fieldsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildLoadingState();
//           } else if (snapshot.hasError) {
//             return _buildErrorState(snapshot.error.toString());
//           } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
//             return _buildEmptyState();
//           } else {
//             final fields = snapshot.data!.data;

//             // Filter fields based on search query
//             final filteredFields = fields.where((field) {
//               return field.name.toLowerCase().contains(
//                 _searchQuery.toLowerCase(),
//               );
//             }).toList();

//             return Column(
//               children: [
//                 // Search Bar
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: "Cari lapangan...",
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value;
//                       });
//                     },
//                   ),
//                 ),

//                 Expanded(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     itemCount: filteredFields.length,
//                     itemBuilder: (context, index) {
//                       final field = filteredFields[index];
//                       return _buildFieldCard(field);
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// // Helper function untuk format rupiah (pastikan sudah ada di file Anda)
// String formatRupiah(String price) {
//   // Implementasi format rupiah Anda
//   return "Rp ${price.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
// }

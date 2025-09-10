import 'package:flutter/material.dart';
import 'package:project_2/app_crud/pages/detail_login/pages_tambahan/build_rp.dart';
import 'package:project_2/app_crud/pages/detail_login/pages_tambahan/corousel_rp.dart'
    hide formatRupiah;
import 'package:project_2/app_crud/screens/jadwal_screen.dart';
import 'package:project_2/app_crud/models/get_lapangan.dart';
import 'package:project_2/app_crud/pages/Api/authentication.dart';
import 'package:project_2/app_crud/pages/detail_login/pages_tambahan/card_rp.dart';
import 'package:project_2/app_crud/screens/add_schedule_screen.dart';

class DashboardUser extends StatefulWidget {
  static const String routeName = '/Book';
  const DashboardUser({super.key});
  @override
  State<DashboardUser> createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser> {
  late Future<SportCard> fieldsFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Datum> _allFields = [];
  List<Datum> _filteredFields = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    fieldsFuture = AuthenticationAPI.getFields();
    fieldsFuture.then((sportCard) {
      setState(() {
        _allFields = sportCard.data;
        _filteredFields = _allFields;
      });
    });

    // Add listener to search controller
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    if (query.isEmpty) {
      setState(() {
        _filteredFields = _allFields;
        _isSearching = false;
      });
    } else {
      setState(() {
        _filteredFields = _allFields.where((field) {
          return field.name.toLowerCase().contains(query);
        }).toList();
        _isSearching = true;
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredFields = _allFields;
      _isSearching = false;
    });
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Cari lapangan futsal...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
              onPressed: _clearSearch,
            ),
          const SizedBox(width: 4),
          const Icon(Icons.filter_list, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildFieldsGrid(List<Datum> fields) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.7 / 4,
        ),
        itemCount: fields.length,
        itemBuilder: (context, index) {
          final field = fields[index];
          return buildFieldCard(field, context);
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredFields.isEmpty && _isSearching) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Lapangan tidak ditemukan",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              "Coba dengan kata kunci lain",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return _buildFieldsGrid(_filteredFields);
  }

  Widget _buildNormalContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carousel Section
        FutureBuilder<SportCard>(
          future: fieldsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.data.isEmpty) {
              return const SizedBox.shrink();
            } else {
              final featuredFields = snapshot.data!.data.take(3).toList();
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lapangan Populer",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 220,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: CarouselSliderWidget(featuredFields: featuredFields),
                  ),
                ],
              );
            }
          },
        ),

        // Recommended Fields Section
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(
            "Rekomendasi Lapangan",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        // Fields Grid
        FutureBuilder<SportCard>(
          future: fieldsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
              return const Center(child: Text("Tidak ada data lapangan"));
            } else {
              final fields = snapshot.data!.data;
              return _buildFieldsGrid(fields);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Halo, Selamat Datang!",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Sewa Lapangan Futsal",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.person, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Bar
              _buildSearchBar(),

              // Conditional Content based on search state
              _isSearching ? _buildSearchResults() : _buildNormalContent(),
            ],
          ),
        ),
      ),
    );
  }
}

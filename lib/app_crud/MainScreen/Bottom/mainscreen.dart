// main_screen.dart
import 'package:flutter/material.dart';
import 'package:project_2/app_crud/MainScreen/Bottom/bookmarkscreen.dart';
import 'package:project_2/app_crud/MainScreen/Bottom/categoriesscreen.dart';
import 'package:project_2/app_crud/MainScreen/Bottom/jadwal_page.dart';
import 'package:project_2/app_crud/MainScreen/bottom.dart';
import 'package:project_2/app_crud/pages/detail_login/dashboard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardUser(),
    const CategoriesScreen(),
    const JadwalScreen(fieldId: 0, fieldName: 'Default Field'),
    const BookmarkScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToJadwalScreen(int fieldId, String fieldName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            JadwalScreen(fieldId: fieldId, fieldName: fieldName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

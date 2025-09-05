// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:project_2/app_crud/MainScreen/Bottom/mainscreen.dart';
import 'package:project_2/app_crud/pages/detail_login/detail_user.dart';
import 'package:project_2/app_crud/preference/shared_preference.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/Welcome';
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await PreferenceHandler.getLogin();
    String? token = await PreferenceHandler.getToken();

    if (isLoggedIn && token != null) {
      // Navigate to book list if already logged in
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // Show welcome screen for a moment then navigate to login
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DetailUser()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image(image: AssetImage("assets/images/foto/logo2.png")),
            ),
          ),
          if (_isLoading)
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          RichText(
            text: TextSpan(
              text: 'Powered by ',
              style: const TextStyle(
                color: Color.fromARGB(255, 121, 117, 117),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Aldi Kurniawan',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          // Loading indicator
        ],
      ),
    );
  }
}

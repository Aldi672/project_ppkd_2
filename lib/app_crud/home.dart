import 'package:flutter/material.dart';
import 'package:project_2/app_crud/pages/detail_login/detail_user.dart';
import 'package:project_2/app_crud/pages/login-register_api/login_user.dart';
import 'package:project_2/app_crud/pages/login-register_api/register_user.dart';
import 'package:project_2/app_crud/screens/welcome_screen.dart';

class BookApp extends StatelessWidget {
  static const String routeName = '/bookapp';
  const BookApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manajemen Buku Pribadi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: WelcomeScreen.routeName,

      routes: {
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        DetailUser.routeName: (context) => const DetailUser(),
        BookApp.routeName: (context) => const BookApp(),
        UserLogin.routeName: (context) => const UserLogin(),
        RegisterUser.routeName: (context) => const RegisterUser(),
      },
    );
  }
}

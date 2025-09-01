import 'package:flutter/material.dart';
import 'package:project_2/app_crud/pages/login-register_api/login_user.dart';
import 'package:project_2/app_crud/pages/login-register_api/register_user.dart';

class DetailUser extends StatelessWidget {
  static const String routeName = '/detail';
  const DetailUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Column(
        children: [
          SizedBox(
            width: double.maxFinite,

            child: Image(image: AssetImage("assets/images/foto/nyoba2.png")),
          ),

          SizedBox(
            height: 200,
            child: Image(image: AssetImage("assets/images/foto/logo2.png")),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Main Futsal Jadi Lebih Mudah!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 40, right: 40),
                  child: const Text(
                    'Booking lapangan futsal kapan saja, di mana saja.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontFamily: "static",
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,

                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Pusatkan vertikal
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Pusatkan horizontal
                        children: [
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to Create Account screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterUser(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF2575FC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to Create Account screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UserLogin(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF2575FC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

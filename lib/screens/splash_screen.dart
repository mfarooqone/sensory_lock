import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      Get.offAll(
        () => WelcomeScreen(),
      ); // Navigate to WelcomeScreen after 5 seconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF064663), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splashscreenlogo.png',
              width: 250,
            ), // Replace with your logo
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

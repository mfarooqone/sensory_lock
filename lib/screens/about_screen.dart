import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const appColor = Color(0xFF064663);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 90,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: const Text(
            "About",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: appColor,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: appColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30), // move box lower
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: appColor, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'Smart Sensor Entry is an IoT-powered app that enhances security and streamlines access management for businesses and facilities. It offers secure admin login, a user management dashboard, live entry monitoring, and remote control capabilities. This innovative solution combines ease of use with advanced security, making it a reliable and efficient solution for modern access control needs.',
                style: TextStyle(
                  fontSize: 16,
                  color: appColor,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Current Version 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: appColor.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

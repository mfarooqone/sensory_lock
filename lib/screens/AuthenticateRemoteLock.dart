import 'package:flutter/material.dart';
import 'remote_lock_unlock.dart'; // Import the next page

class AuthenticateRemoteLock extends StatelessWidget {
  const AuthenticateRemoteLock({super.key});

  static const appColor = Color(0xFF064663);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Low-opacity background image
          Opacity(
            opacity: 0.45,
            child: Image.asset(
              'assets/images/lock_bg.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Back button
          Positioned(
            top: 50,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: appColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Authenticate\nYourself",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: appColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "You have to authenticate first to\nremotely open/close the door",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom AppBar
      bottomNavigationBar: BottomAppBar(
        color: appColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(height: 60),
      ),

      // Floating Fingerprint Button
      floatingActionButton: GestureDetector(
        onTap: () {
          // Show authentication dialog (you can replace with actual fingerprint check)
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Authentication"),
              content: const Text("Fingerprint authentication triggered."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    // Navigate to RemoteLockUnlock page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RemoteLockUnlock()),
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.fingerprint, size: 40, color: appColor),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

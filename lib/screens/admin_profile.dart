import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'settings.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  static const appColor = Color(0xFF064663);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 90,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text(
            "Profile",
            style: TextStyle(
              color: appColor,
              fontWeight: FontWeight.bold,
              fontSize: 28,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: const AssetImage('assets/images/profilepic.png'),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailField("Name", "Mark Zukerburg"),
            _buildDetailField("ID", "45-67859"),
            _buildDetailField("Email", "zu_b09@gmail.com"),
            _buildDetailField("Phone", "091-789327463"),
            _buildDetailField("Age", "32"),
            _buildDetailField("Gender", "Male"),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: appColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: const BorderSide(color: Color(0xFFDBE0E7), width: 1.5),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Info', style: TextStyle(color: appColor)),
              content: const Text('Camera function is not yet implemented.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK', style: TextStyle(color: appColor)),
                ),
              ],
            ),
          );
        },
        child: Image.asset(
          'assets/images/camera.png',
          height: 28,
          width: 20,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: appColor, width: 1.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(
                color: appColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: appColor,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

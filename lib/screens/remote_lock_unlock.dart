import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'settings.dart';
import 'locked_page.dart';
import 'unlocked_page.dart';


class RemoteLockUnlock extends StatelessWidget {
  const RemoteLockUnlock({super.key});

  static const appColor = Color(0xFF064663);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // match background
      appBar: AppBar(
        backgroundColor: Colors.white, // white bg
        elevation: 0, // no shadow
        toolbarHeight: 90, // taller toolbar
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text(
            "Real-Time",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: appColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Lock list item
            _buildListItem(
              icon: Icons.lock,
              title: 'Lock the door',
              onTap: () => _showDisclaimer(context, true),
            ),

            // Unlock list item
            _buildListItem(
              icon: Icons.lock_open,
              title: 'Unlock the door',
              onTap: () => _showDisclaimer(context, false),
            ),
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

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: appColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: appColor,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: appColor),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }

  void _showDisclaimer(BuildContext context, bool isLock) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Disclaimer!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: appColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Do you really want to ${isLock ? "Lock" : "Unlock"} the door?',
                style: const TextStyle(color: appColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF731F1F), // Yes button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Yes', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColor, // No button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('No', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((result) {
      if (result == null) return;
      if (result) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => isLock ? const LockedPage() : const UnlockedPage(),
          ),
        );
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'help_screen.dart';
import 'about_screen.dart';
import 'auth/login_screen.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final List<_SettingItem> _allSettings;
  List<_SettingItem> _filteredSettings = [];

  static const appColor = Color(0xFF064663);

  @override
  void initState() {
    super.initState();
    _allSettings = [
      _SettingItem(
        "Help",
        Icons.help_outline,
            () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HelpScreen()),
          );
        },
        iconColor: Colors.white,
        iconBackground: const Color(0xFFB97CC3),
      ),
      _SettingItem(
        "About",
        Icons.info_outline,
            () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutScreen()),
          );
        },
        iconColor: Colors.white,
        iconBackground: const Color(0xFF3C82AB),
      ),
      _SettingItem(
        "Logout",
        Icons.logout,
            () {
          _showLogoutDialog(context);
        },
        iconColor: Colors.white,
        iconBackground: const Color(0xFFFB6B66),
        textColor: Colors.red,
      ),
    ];

    _filteredSettings = _allSettings;
    _searchController.addListener(_filterSettings);
  }

  void _filterSettings() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSettings = _allSettings
          .where((item) => item.title.toLowerCase().contains(query))
          .toList();
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
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
              const SizedBox(height: 20),
              Flexible(
                child: const Text.rich(
                  TextSpan(
                    text: 'Do you want to ',
                    style: TextStyle(color: appColor),
                    children: [
                      TextSpan(
                        text: 'Logout',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' your account?'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF731F1F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Text('Yes', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            "Settings",
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
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, color: appColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredSettings.length,
                itemBuilder: (context, index) {
                  final item = _filteredSettings[index];
                  final isLogout = item.title == "Logout";

                  return Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: item.iconBackground ?? Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            item.icon,
                            color: item.iconColor ?? Colors.black,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            color: isLogout ? Colors.red : item.textColor,
                            fontWeight: FontWeight.normal, // <-- Unbold all titles
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: isLogout ? Colors.red : appColor,
                        ),
                        onTap: item.onTap,
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: appColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                  // Already on settings
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
                )
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
}

class _SettingItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color textColor;
  final Color? iconColor;
  final Color? iconBackground;

  _SettingItem(
      this.title,
      this.icon,
      this.onTap, {
        this.textColor = const Color(0xFF064663),
        this.iconColor,
        this.iconBackground,
      });
}

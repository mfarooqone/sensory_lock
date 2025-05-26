import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'settings.dart';

class SystemAlerts extends StatefulWidget {
  const SystemAlerts({Key? key}) : super(key: key);

  @override
  State<SystemAlerts> createState() => _SystemAlertsState();
}

class _SystemAlertsState extends State<SystemAlerts> {
  static const appColor = Color(0xFF064663);

  List<Map<String, dynamic>> allAlerts = [
    {
      "title": "Unauthorised Access",
      "description": "Unauthorised access attempt detected.",
      "color": Colors.red,
      "category": "Critical",
    },
    {
      "title": "User Registration Success",
      "description": "New User Registered Successfully.",
      "color": Colors.grey,
      "category": "General",
    },
    {
      "title": "Low Disk Space",
      "description": "Disk Space running low on server 101.",
      "color": Colors.orange,
      "category": "Warning",
    },
    {
      "title": "System Temperature High",
      "description": "Temperature exceeded threshold.",
      "color": Colors.orange,
      "category": "Warning",
    },
  ];

  String selectedCategory = 'Category'; // default value

  final Map<String, Color> categoryColors = {
    'Critical': Colors.red,
    'Warning': Colors.orange,
    'General': Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final filteredAlerts = selectedCategory == 'Category'
        ? allAlerts
        : allAlerts.where((alert) => alert['category'] == selectedCategory).toList();

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
            "Alerts",
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
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, color: appColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: appColor, // changed to appColor for background
                  border: Border.all(color: appColor),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: appColor,
                    value: selectedCategory,
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    items: <String>['Category', 'Critical', 'Warning', 'General']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            if (value != 'Category')
                              Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: categoryColors[value],
                                ),
                              ),
                            Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4.5), // Added spacing between dropdown and alerts

            // Alerts List
            Expanded(
              child: filteredAlerts.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/no_alerts.png',
                      width: 400,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No alerts to display',
                      style: TextStyle(
                        color: appColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: filteredAlerts.length,
                itemBuilder: (context, index) {
                  final alert = filteredAlerts[index];
                  return Dismissible(
                    key: Key(alert["title"] + index.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: appColor,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        allAlerts.remove(alert);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: appColor,
                          content: Text(
                            "${alert['title']} Dismissed",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    child: _buildAlertTile(
                      title: alert["title"],
                      description: alert["description"],
                      color: alert["color"],
                    ),
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

  Widget _buildAlertTile({
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: color, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            width: 10,
            height: double.infinity,
            color: color,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: appColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(color: appColor),
          ),
        ),
      ),
    );
  }
}

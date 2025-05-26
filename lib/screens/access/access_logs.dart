import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../settings.dart';
import '../visitor_list.dart';

class AccessLogs extends StatefulWidget {
  const AccessLogs({super.key});

  @override
  State<AccessLogs> createState() => _AccessLogsState();
}

class _AccessLogsState extends State<AccessLogs> {
  static const appColor = Color(0xFF064663);

  List<Map<String, dynamic>> allLogs = [
    {
      "srNo": 1,
      "id": 902,
      "access": true,
      "timestamp": DateTime.now().subtract(const Duration(hours: 3)),
    },
    {
      "srNo": 2,
      "id": 456,
      "access": true,
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      "srNo": 3,
      "access": false,  // Example entry without "id"
      "timestamp": DateTime.now().subtract(const Duration(days: 10)),
    },
    {
      "srNo": 4,
      "id": 324,
      "access": true,
      "timestamp": DateTime.now().subtract(const Duration(days: 40)),
    },
    {
      "srNo": 5,
      "access": false, // Another without "id"
      "timestamp": DateTime.now().subtract(const Duration(days: 90)),
    },
    {
      "srNo": 6,
      "id": 231,
      "access": true,
      "timestamp": DateTime.now().subtract(const Duration(days: 100)),
    },
  ];

  List<Map<String, dynamic>> filteredLogs = [];
  String? selectedPeriod = 'All';

  @override
  void initState() {
    super.initState();
    _filterLogs(selectedPeriod);
  }

  void _filterLogs(String? period) {
    final now = DateTime.now();
    DateTime threshold;

    setState(() {
      selectedPeriod = period;

      if (period == '24 hours') {
        threshold = now.subtract(const Duration(hours: 24));
        filteredLogs = allLogs.where((log) => log['timestamp'].isAfter(threshold)).toList();
      } else if (period == '1 month') {
        threshold = DateTime(now.year, now.month - 1, now.day);
        filteredLogs = allLogs.where((log) => log['timestamp'].isAfter(threshold)).toList();
      } else if (period == '3 months') {
        threshold = DateTime(now.year, now.month - 3, now.day);
        filteredLogs = allLogs.where((log) => log['timestamp'].isAfter(threshold)).toList();
      } else {
        filteredLogs = List.from(allLogs);
      }
    });
  }

  Widget _buildStatusDot(bool access) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: access ? Colors.green : Colors.red,
        shape: BoxShape.circle,
      ),
    );
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
            "Access Logs",
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 130,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: selectedPeriod,
                    dropdownColor: appColor,
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    underline: const SizedBox(),
                    isExpanded: true,
                    hint: const Text(
                      'Search for',
                      style: TextStyle(color: Colors.white),
                    ),
                    items: <String>['All', '24 hours', '1 month', '3 months']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _filterLogs(newValue);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Expanded(child: Center(child: Text('Sr. No', style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text('Access', style: TextStyle(fontWeight: FontWeight.bold)))),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: filteredLogs.length,
                itemBuilder: (context, index) {
                  final log = filteredLogs[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text('${log["srNo"]}', style: const TextStyle(color: appColor)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              log.containsKey('id') && log['id'] != null
                                  ? '${log["id"]}'
                                  : '-', // <-- Changed here to show '-' if no id present
                              style: const TextStyle(color: appColor),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: _buildStatusDot(log["access"]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => VisitorListPage()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5), // Height adjusted here
                  child: Text(
                    "Show more details",
                    style: TextStyle(
                      color: appColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: appColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          side: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Notice'),
                content: const Text('Camera function is not yet implemented.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        child: Image.asset(
          'assets/images/camera.png',
          width: 30,
          height: 30,
          color: appColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

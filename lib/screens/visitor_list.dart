import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'settings.dart';

class VisitorListPage extends StatefulWidget {
  const VisitorListPage({super.key});

  @override
  State<VisitorListPage> createState() => _VisitorListPageState();
}

class _VisitorListPageState extends State<VisitorListPage> {
  static const appColor = Color(0xFF064663);

  // Original full visitors list
  final List<Map<String, dynamic>> allVisitors = [
    {
      "srNo": 1,
      "id": 902,
      "entryType": "Guest",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "access": true,
      "image": "assets/images/person1.png"
    },
    {
      "srNo": 2,
      "id": 456,
      "entryType": "Delivery",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "access": false,
      "image": "assets/images/person2.png"
    },
    {
      "srNo": 3,
      "entryType": "Unknown",
      "timestamp": DateTime.now().subtract(const Duration(days: 5)),
      "access": false,
      "image": null
    },
  ];

  List<Map<String, dynamic>> filteredVisitors = [];
  String? selectedPeriod = 'All';

  @override
  void initState() {
    super.initState();
    _filterVisitors(selectedPeriod);
  }

  void _filterVisitors(String? period) {
    final now = DateTime.now();
    DateTime threshold;

    setState(() {
      selectedPeriod = period;

      if (period == '24 hours') {
        threshold = now.subtract(const Duration(hours: 24));
        filteredVisitors = allVisitors.where((visitor) => visitor['timestamp'].isAfter(threshold)).toList();
      } else if (period == '1 month') {
        threshold = DateTime(now.year, now.month - 1, now.day);
        filteredVisitors = allVisitors.where((visitor) => visitor['timestamp'].isAfter(threshold)).toList();
      } else if (period == '3 months') {
        threshold = DateTime(now.year, now.month - 3, now.day);
        filteredVisitors = allVisitors.where((visitor) => visitor['timestamp'].isAfter(threshold)).toList();
      } else {
        filteredVisitors = List.from(allVisitors);
      }
    });
  }

  Widget _buildEntryTypeDot(String entryType) {
    Color dotColor;
    switch (entryType.toLowerCase()) {
      case 'guest':
        dotColor = Colors.green;
        break;
      case 'delivery':
        dotColor = Colors.red;
        break;
      default:
        dotColor = Colors.grey;
    }
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: dotColor,
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
            "Visitors",
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
                hintText: "Search Visitors",
                prefixIcon: const Icon(Icons.search, color: appColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Dropdown filter, styled like your AccessLogs example
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
                    items: <String>['All', '24 hours', '1 month', '3 months']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _filterVisitors(newValue);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 700,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: const [
                            SizedBox(width: 80, child: Center(child: Text('Sr. No', style: TextStyle(fontWeight: FontWeight.bold)))),
                            SizedBox(width: 80, child: Center(child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)))),
                            SizedBox(width: 100, child: Center(child: Text('Entry Type', style: TextStyle(fontWeight: FontWeight.bold)))),
                            SizedBox(width: 180, child: Center(child: Text('Timestamp', style: TextStyle(fontWeight: FontWeight.bold)))),
                            SizedBox(width: 100, child: Center(child: Text('Access', style: TextStyle(fontWeight: FontWeight.bold)))),
                            SizedBox(width: 100, child: Center(child: Text('Image', style: TextStyle(fontWeight: FontWeight.bold)))),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredVisitors.length,
                          itemBuilder: (context, index) {
                            final visitor = filteredVisitors[index];
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
                                  SizedBox(width: 80, child: Center(child: Text('${visitor["srNo"]}', style: const TextStyle(color: appColor)))),
                                  SizedBox(width: 80, child: Center(child: Text(visitor.containsKey('id') ? '${visitor["id"]}' : '-', style: const TextStyle(color: appColor)))),
                                  SizedBox(width: 100, child: Center(child: _buildEntryTypeDot(visitor["entryType"]))),
                                  SizedBox(width: 180, child: Center(child: Text('${visitor["timestamp"].toString().split(".")[0]}', style: const TextStyle(color: appColor, fontSize: 11)))),
                                  SizedBox(width: 100, child: Center(child: Text(visitor["access"] ? "Granted" : "Access", style: const TextStyle(color: appColor, fontSize: 12)))),
                                  const SizedBox(width: 100, child: Center(child: Text("image.png", style: TextStyle(color: appColor, fontSize: 12)))),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
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

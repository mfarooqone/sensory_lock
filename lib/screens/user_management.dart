import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'settings.dart';
import 'add_user_screen.dart';
import 'profile/user_profile.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  static const appColor = Color(0xFF064663);

  List<Map<String, String>> allUsers = []; // Removed hardcoded users
  List<Map<String, String>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = List.from(allUsers);
  }

  void _filterUsers(String query) {
    final filtered = allUsers.where((user) {
      final nameLower = user["name"]!.toLowerCase();
      final idLower = user["id"]!.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower) || idLower.contains(searchLower);
    }).toList();
    setState(() {
      filteredUsers = filtered;
    });
  }

  void _addUser(Map<String, String> newUser) {
    setState(() {
      allUsers.add(newUser);
      filteredUsers = List.from(allUsers);
    });
  }

  void _updateUser(Map<String, String> updatedUser) {
    setState(() {
      final index = allUsers.indexWhere((u) => u['id'] == updatedUser['id']);
      if (index != -1) {
        allUsers[index] = updatedUser;
        filteredUsers = List.from(allUsers);
      }
    });
  }

  void _deleteUser(String userId) {
    setState(() {
      allUsers.removeWhere((u) => u['id'] == userId);
      filteredUsers = List.from(allUsers);
    });
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
          child: Text("Users", style: TextStyle(color: appColor, fontWeight: FontWeight.bold, fontSize: 28)),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _filterUsers,
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search, color: appColor),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddUserScreen(existingUsers: allUsers)),
                    );
                    if (result != null) _addUser(result);
                  },
                  child: const Text("Add User", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredUsers.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return _buildUserItem(user);
                },
              )
                  : const Center(
                child: Text("No users found", style: TextStyle(fontSize: 18, color: Colors.grey)),
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
        child: Image.asset('assets/images/camera.png', height: 28, width: 20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildUserItem(Map<String, String> user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: user["avatarUrl"] != null && user["avatarUrl"]!.isNotEmpty
                ? NetworkImage(user["avatarUrl"]!)
                : const AssetImage('assets/default_avatar.png') as ImageProvider,
            radius: 25,
          ),
          title: Text(
            user["name"] ?? '',
            style: const TextStyle(color: appColor, fontWeight: FontWeight.normal, fontSize: 16),
          ),
          trailing: Text(
            user["id"] ?? '',
            style: const TextStyle(color: appColor, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          onTap: () async {



            
            final updatedUser = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileScreen(
                  user: user,
                  onUpdate: _updateUser,
                  onDelete: () => _deleteUser(user['id']!),
                ),
              ),
            );
            if (updatedUser != null) _updateUser(updatedUser);
          },
        ),
      ),
    );
  }
}

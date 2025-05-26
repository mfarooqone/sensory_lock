import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensory_app/screens/profile/profile_controller.dart';
import 'package:sensory_app/screens/profile/user_model.dart';
import 'package:sensory_app/screens/profile/user_profile.dart';

import 'add_user_screen.dart';
import 'home_screen.dart';
import 'settings.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  static const appColor = Color(0xFF064663);

  final ProfileController controller = Get.find<ProfileController>();

  @override
  void initState() {
    controller.getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              toolbarHeight: 90,
              centerTitle: true,
              title: const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  "Users",
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          // onChanged: _filterUsers,
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: const Icon(
                              Icons.search,
                              color: appColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                        ),
                        onPressed: () async {
                          await Get.to(() => AddUserScreen());
                          await controller.getAllUsers();
                        },
                        child: const Text(
                          "Add User",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: controller.filteredUserList.isNotEmpty
                        ? ListView.builder(
                            itemCount: controller.filteredUserList.length,
                            itemBuilder: (context, index) {
                              final user = controller.filteredUserList[index];
                              return _buildUserItem(user);
                            },
                          )
                        : const Center(
                            child: Text(
                              "No users found",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
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
              notchMargin: 15,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
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
                    title: const Text(
                      'Info',
                      style: TextStyle(color: appColor),
                    ),
                    content: const Text(
                      'Camera function is not yet implemented.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'OK',
                          style: TextStyle(color: appColor),
                        ),
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
          if (controller.isLoading.value)
            const Center(child: CircularProgressIndicator()),
        ],
      );
    });
  }

  Widget _buildUserItem(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: user.imageUrl.isNotEmpty
                ? NetworkImage(user.imageUrl)
                : const NetworkImage(
                    'https://icons.veryicon.com/png/o/miscellaneous/two-color-webpage-small-icon/user-244.png',
                  ),
            radius: 25,
          ),
          title: Text(
            user.name,
            style: const TextStyle(
              color: appColor,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.email,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                user.id,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),

          onTap: () async {
            final result = await Get.to(() => UserProfileScreen(user: user));
            if (result == true) {
              await controller.getAllUsers();
            }
          },
        ),
      ),
    );
  }
}

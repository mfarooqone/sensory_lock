import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensory_app/screens/profile/profile_controller.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  static const appColor = Color(0xFF064663);
  final ProfileController controller = Get.put(ProfileController());

  final nameController = TextEditingController();
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    controller.isLoading.value = true;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    emailController.text = user.email!;
    idController.text = user.uid;

    final data = await controller.getUserData(user.uid);
    if (data != null) {
      setState(() {
        nameController.text = data['name'] ?? '';
        phoneController.text = data['phone'] ?? '';
        ageController.text = data['age']?.toString() ?? '';
        genderController.text = data['gender'] ?? '';
      });
    }
    controller.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: const AssetImage(
                        'assets/images/profilepic.png',
                      ),
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildEditableField("ID", Icons.badge, idController, false),
                  _buildEditableField(
                    "Email",
                    Icons.email,
                    emailController,
                    false,
                  ),
                  _buildEditableField(
                    "Name",
                    Icons.person,
                    nameController,
                    true,
                  ),
                  _buildEditableField(
                    "Phone",
                    Icons.phone,
                    phoneController,
                    true,
                  ),
                  _buildEditableField("Age", Icons.cake, ageController, true),
                  _buildEditableField(
                    "Gender",
                    Icons.transgender,
                    genderController,
                    true,
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      await controller.saveUserData(
                        uid: user.uid,
                        email: user.email!,
                        name: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        age: int.tryParse(ageController.text.trim()) ?? 0,
                        gender: genderController.text.trim(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D5E74),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Update",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: appColor),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        // bottomNavigationBar: BottomAppBar(
        //   color: appColor,
        //   shape: const CircularNotchedRectangle(),
        //   notchMargin: 15,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         IconButton(
        //           icon: const Icon(Icons.home, color: Colors.white),
        //           onPressed: () {
        //             Navigator.pushReplacement(
        //               context,
        //               MaterialPageRoute(builder: (_) => const HomeScreen()),
        //             );
        //           },
        //         ),
        //         IconButton(
        //           icon: const Icon(Icons.settings, color: Colors.white),
        //           onPressed: () {
        //             Navigator.pushReplacement(
        //               context,
        //               MaterialPageRoute(builder: (_) => const SettingsScreen()),
        //             );
        //           },
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.white,
        //   elevation: 6,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(100),
        //     side: const BorderSide(color: Color(0xFFDBE0E7), width: 1.5),
        //   ),
        //   onPressed: () {
        //     showDialog(
        //       context: context,
        //       builder: (_) => AlertDialog(
        //         title: const Text('Info', style: TextStyle(color: appColor)),
        //         content: const Text('Camera function is not yet implemented.'),
        //         actions: [
        //           TextButton(
        //             onPressed: () => Navigator.pop(context),
        //             child: const Text('OK', style: TextStyle(color: appColor)),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        //   child: Image.asset('assets/images/camera.png', height: 28, width: 20),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }

  Widget _buildEditableField(
    String label,
    IconData icon,
    TextEditingController controller,
    bool enable,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: enable,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: appColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: appColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: appColor, width: 2),
          ),
        ),
      ),
    );
  }
}

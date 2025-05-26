// ✅ UserProfileScreen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensory_app/screens/profile/profile_controller.dart';
import 'package:sensory_app/screens/profile/user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final UserModel user;

  const UserProfileScreen({super.key, required this.user});

  static const appColor = Color(0xFF064663);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    final nameController = TextEditingController(text: user.name);
    final roleController = TextEditingController(text: user.role);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    final ageController = TextEditingController(text: user.age.toString());
    final genderController = TextEditingController(text: user.gender);

    final isEditing = false.obs;

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 90,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              user.name,
              style: const TextStyle(
                color: appColor,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: appColor),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: user.imageUrl.isNotEmpty
                          ? NetworkImage(user.imageUrl)
                          : const NetworkImage(
                              'https://icons.veryicon.com/png/o/miscellaneous/two-color-webpage-small-icon/user-244.png',
                            ),
                    ),
                    const SizedBox(height: 20),
                    _buildField(
                      "ID",
                      TextEditingController(text: user.id),
                      false,
                    ),
                    _buildField("Name", nameController, isEditing.value),
                    _buildField("Role", roleController, isEditing.value),
                    _buildField("Email", emailController, false),
                    _buildField("Phone", phoneController, isEditing.value),
                    _buildField("Age", ageController, isEditing.value),
                    _buildField("Gender", genderController, isEditing.value),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (isEditing.value) {
                              await controller.saveUserData(
                                uid: user.id,
                                email: emailController.text.trim(),
                                name: nameController.text.trim(),
                                phone: phoneController.text.trim(),
                                age:
                                    int.tryParse(ageController.text.trim()) ??
                                    0,
                                gender: genderController.text.trim(),
                              );
                              isEditing.value = false;
                              Get.back(result: true);
                            } else {
                              isEditing.value = true;
                            }
                          },
                          icon: Icon(isEditing.value ? Icons.save : Icons.edit),
                          label: Text(isEditing.value ? "Save" : "Edit"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final confirm = await _confirmDelete(context);
                            if (confirm) {
                              await controller.deleteUser(user.id);
                              Get.back(result: true);
                            }
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      );
    });
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    bool editable,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(
                color: appColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: editable
                ? TextField(
                    controller: controller,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: UnderlineInputBorder(),
                    ),
                  )
                : Text(controller.text, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Disclaimer!", textAlign: TextAlign.center),
            content: const Text(
              "Do you really want to Delete this User detail?",
              textAlign: TextAlign.center,
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Yes", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () => Navigator.pop(context, false),
                child: const Text("No", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }
}

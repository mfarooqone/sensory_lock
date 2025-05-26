import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'settings.dart';

class UserProfileScreen extends StatefulWidget {
  final Map<String, String> user;
  final Function(Map<String, String> updatedUser)? onUpdate;
  final Function()? onDelete;

  const UserProfileScreen({
    Key? key,
    required this.user,
    this.onUpdate,
    this.onDelete,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  static const appColor = Color(0xFF064663);

  bool isEditing = false;

  late Map<String, String> originalUserData;

  late TextEditingController nameController;
  late TextEditingController roleController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController ageController;
  late TextEditingController genderController;

  @override
  void initState() {
    super.initState();
    originalUserData = Map<String, String>.from(widget.user);
    _initControllers();
  }

  void _initControllers() {
    nameController = TextEditingController(text: originalUserData['name']);
    roleController = TextEditingController(text: originalUserData['role'] ?? '');
    emailController = TextEditingController(text: originalUserData['email'] ?? '');
    phoneController = TextEditingController(text: originalUserData['phone'] ?? '');
    ageController = TextEditingController(text: originalUserData['age'] ?? '');
    genderController = TextEditingController(text: originalUserData['gender'] ?? '');
  }

  void _resetControllers() {
    nameController.text = originalUserData['name'] ?? '';
    roleController.text = originalUserData['role'] ?? '';
    emailController.text = originalUserData['email'] ?? '';
    phoneController.text = originalUserData['phone'] ?? '';
    ageController.text = originalUserData['age'] ?? '';
    genderController.text = originalUserData['gender'] ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    genderController.dispose();
    super.dispose();
  }

  void _saveEdits() {
    final updatedUser = {
      ...originalUserData,
      'name': nameController.text.trim(),
      'role': roleController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'age': ageController.text.trim(),
      'gender': genderController.text.trim(),
    };

    originalUserData = Map<String, String>.from(updatedUser);

    if (widget.onUpdate != null) {
      widget.onUpdate!(updatedUser);
    }
    setState(() => isEditing = false);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 300),
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
              const Text.rich(
                TextSpan(
                  text: 'Do you want to ',
                  style: TextStyle(color: appColor),
                  children: [
                    TextSpan(
                      text: 'delete',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' this user?'),
                  ],
                ),
                textAlign: TextAlign.center,
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
                        Navigator.pop(context); // close dialog
                        if (widget.onDelete != null) widget.onDelete!();
                        Navigator.pop(context); // pop profile screen after delete
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
                      onPressed: () => Navigator.pop(context),
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

  Future<bool> _onWillPop() async {
    if (isEditing) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          content: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Discard Changes?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: appColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'You have unsaved changes. Discard and go back?',
                  style: TextStyle(color: appColor),
                  textAlign: TextAlign.center,
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
                          Navigator.pop(context, true);
                        },
                        child: const Text('Discard', style: TextStyle(color: Colors.white)),
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
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (discard == true) {
        _resetControllers();
        setState(() {
          isEditing = false;
        });
        return false; // prevent pop because we handled it here
      }
      return false; // cancel pop
    }
    return true; // allow pop
  }

  Widget _buildInfoRow(String label, TextEditingController controller, {bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: appColor,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: isEditing && isEditable
                ? TextField(
              controller: controller,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                border: UnderlineInputBorder(),
              ),
            )
                : Text(
              controller.text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 90,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              originalUserData["name"] ?? "User Profile",
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
              onPressed: () async {
                final shouldPop = await _onWillPop();
                if (shouldPop) Navigator.pop(context);
              },
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: originalUserData["avatarUrl"] != null &&
                            originalUserData["avatarUrl"]!.isNotEmpty
                            ? NetworkImage(originalUserData["avatarUrl"]!)
                            : const AssetImage('assets/default_avatar.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F9FA),
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // ID is NOT editable
                            _buildInfoRow("ID", TextEditingController(text: originalUserData["id"] ?? ""), isEditable: false),
                            _buildInfoRow("Name", nameController),
                            _buildInfoRow("Role", roleController),
                            _buildInfoRow("Email", emailController),
                            _buildInfoRow("Phone", phoneController),
                            _buildInfoRow("Age", ageController),
                            _buildInfoRow("Gender", genderController),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            if (isEditing) {
                              _saveEdits();
                            } else {
                              setState(() => isEditing = true);
                            }
                          },
                          icon: Icon(isEditing ? Icons.save : Icons.edit),
                          label: Text(isEditing ? 'Save' : 'Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _confirmDelete,
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF630606),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
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
          child: Image.asset('assets/images/camera.png', height: 28, width: 20),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

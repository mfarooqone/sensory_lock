import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensory_app/screens/utils/show_snackbar.dart';

import '../profile/profile_controller.dart';
import '../verification_screen.dart'; // Make sure this file exists

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              toolbarHeight: 100, // Increased toolbar height
              leading: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  top: 40,
                ), // More top padding to lower arrow
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xFF064663)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  50,
                  16,
                  16,
                ), // More top padding for content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/forgotpassword1.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Forgot Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF064663),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Enter Your Recovery Email Address.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xFF064663)),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email Address",
                        prefixIcon: Icon(Icons.email, color: Color(0xFF064663)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (emailController.text.isEmpty) {
                          showErrorMessage("Please enter your email address.");
                          return;
                        }
                        await controller.sendOtp(email: emailController.text);
                        Get.to(() => VerificationScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF064663),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Send",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.isLoading.value)
            Center(child: CircularProgressIndicator()),
        ],
      );
    });
  }
}

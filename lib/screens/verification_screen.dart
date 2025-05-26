import 'package:flutter/material.dart';
import 'auth/new_password_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✓ Code Resent!!"),
        backgroundColor: Color(0xFF064663),
      ),
    );
  }

  void _verifyCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100, // taller to allow vertical padding
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 40), // lowered back arrow
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF064663)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 50), // vertical align with arrow
          child: Text(
            "Verification",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF064663),
            ),
          ),
        ),
        centerTitle: true, // center the title horizontally
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 16), // extra top padding for space between appbar and image
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/verify.png',
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                "Please Enter Your Verification Code.",
                style: TextStyle(fontSize: 16, color: Color(0xFF064663)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Enter Code",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF064663)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resendCode,
                  child: Text(
                    "Resend Code",
                    style: TextStyle(color: Color(0xFF064663)),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF064663),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Verify",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

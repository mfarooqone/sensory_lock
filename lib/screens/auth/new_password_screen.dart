import 'package:flutter/material.dart';
import 'password_changed_screen.dart'; // Make sure this screen exists

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _handleDone() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword == confirmPassword && newPassword.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PasswordChangedScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords don’t match."),
          backgroundColor: Color(0xFF064663),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label, bool obscure, VoidCallback toggle) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF064663)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF064663)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF064663), width: 2),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: Color(0xFF064663),
        ),
        onPressed: toggle,
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
        toolbarHeight: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 40),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF064663)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text(
            "Create New Password",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF064663),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
          child: Column(
            children: [
              Image.asset(
                'assets/images/resetpassword.png',
                height: 180,
              ),
              SizedBox(height: 20),
              Text(
                "Enter Your New Password.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF064663),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _newPasswordController,
                obscureText: _obscurePassword,
                decoration: _inputDecoration("New Password", _obscurePassword, () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                }),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: _inputDecoration("Confirm Password", _obscureConfirmPassword, () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                }),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handleDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF064663),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Done",
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

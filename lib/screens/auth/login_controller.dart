import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      log("userCredential === ${userCredential.user!.emailVerified}");

      // Sign-in successful
      return null; // null indicates success
    } on FirebaseAuthException catch (e) {
      // Handle known Firebase errors
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      } else if (e.code == 'user-disabled') {
        return 'This user account has been disabled.';
      } else {
        return 'FirebaseAuth Error: ${e.message}';
      }
    } catch (e) {
      // Handle unexpected errors
      return 'Unexpected error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}

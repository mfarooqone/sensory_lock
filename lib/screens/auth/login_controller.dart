import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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

      log("userCredential === ${userCredential.user!.email}");

      await saveUserEmailToFirestore();

      return null; // success
    } on FirebaseAuthException catch (e) {
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
      log("Unexpected error: $e");
      return 'Unexpected error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveUserEmailToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid);

    await userDoc.set({
      'email': user.email,
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }
}

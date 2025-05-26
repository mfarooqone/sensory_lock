import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../utils/show_snackbar.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;

  /// Fetch user data from Firestore using UID
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        return doc.data();
      } else {
        showErrorMessage("No data found for this user.");
        return null;
      }
    } catch (e) {
      log("Fetch error: $e");
      showErrorMessage("Failed to fetch user data.");
      return null;
    }
  }

  /// Save or update user data
  Future<void> saveUserData({
    required String uid,
    required String email,
    required String name,
    required String phone,
    required int age,
    required String gender,
  }) async {
    isLoading.value = true;
    final userData = {
      'email': email,
      'name': name,
      'phone': phone,
      'age': age,
      'gender': gender,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData, SetOptions(merge: true));
      showSuccessMessage("Profile updated successfully");
    } catch (e) {
      showErrorMessage("Update failed: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}

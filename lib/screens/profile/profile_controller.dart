import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sensory_app/screens/profile/user_model.dart';

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

  ///
  ///
  ///
  ///

  Future<void> createNewUserInFirestore({
    required String name,
    required String role,
    required String email,
    required String phone,
    required int age,
    required String gender,
  }) async {
    try {
      isLoading.value = true;

      final userData = {
        'name': name,
        'role': role,
        'email': email,
        'phone': phone,
        'age': age,
        'gender': gender,
        'createdAt': DateTime.now().toIso8601String(),
      };
      await FirebaseFirestore.instance.collection('users').add(userData);
      showSuccessMessage("New user added successfully");
    } catch (e) {
      showErrorMessage("Failed to add user: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  ///
  ///
  ///
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        return UserModel.fromMap(doc.id, doc.data()!);
      } else {
        showErrorMessage("User not found.");
        return null;
      }
    } catch (e) {
      showErrorMessage("Error fetching user: ${e.toString()}");
      return null;
    }
  }

  ///
  ///
  ///
  var userList = <UserModel>[].obs;
  var filteredUserList = <UserModel>[].obs;

  /// Fetch all users from Firestore
  Future<void> getAllUsers() async {
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      final users = snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.id, doc.data());
      }).toList();

      userList.assignAll(users);
      filteredUserList.assignAll(users); // initialize filtered list
    } catch (e) {
      showErrorMessage("Failed to load users: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void filterUsersByName(String query) {
    if (query.isEmpty) {
      filteredUserList.assignAll(userList);
    } else {
      final results = userList
          .where(
            (user) => user.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      filteredUserList.assignAll(results);
    }
  }

  ///
  ///
  ///
  ///
  Future<void> deleteUser(String uid) async {
    try {
      isLoading.value = true;

      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      showSuccessMessage("User deleted successfully");
      await getAllUsers(); // Refresh the list after deletion
    } catch (e) {
      showErrorMessage("Failed to delete user: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}

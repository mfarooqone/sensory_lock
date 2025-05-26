import 'package:flutter/material.dart';
import 'package:get/get.dart';

///
///
///
void showSuccessMessage(
  String message, {
  ScaffoldMessengerState? messengerState,
}) {
  final s = messengerState ?? ScaffoldMessenger.of(Get.context!);
  s.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
      ),
      backgroundColor: Colors.green,
    ),
  );
}

///
///
///
void showErrorMessage(
  String message, {
  ScaffoldMessengerState? messengerState,
}) {
  final s = messengerState ?? ScaffoldMessenger.of(Get.context!);
  s.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
      ),
      backgroundColor: Colors.red,
    ),
  );
}

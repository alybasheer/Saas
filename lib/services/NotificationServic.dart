import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Initialize FCM and setup handlers
  Future<void> init() async {
    await _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    Get.snackbar(
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
    );
  }

  // Send reminder to a user
  Future<void> sendReminder(String userId, String message) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final token = userDoc.data()?['fcmToken'];
    if (token != null) {
      // In a real app, call FCM API here (e.g., via Firebase Functions)
      debugPrint('Sending to $token: $message');
    }
  }
}
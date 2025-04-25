import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Initializes FCM permissions and message handlers
  Future<void> init() async {
    try {
      await _fcm.requestPermission();

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleMessage);

      // Optionally handle background and terminated state messages
      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      debugPrint('FCM Init Error: $e');
    }
  }

  /// Display received message as a Snackbar
  void _handleMessage(RemoteMessage message) {
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';

    if (body.isNotEmpty) {
      Get.snackbar(
        title,
        body,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Sends a reminder (just logs here; you'd use Firebase Functions in production)
  Future<void> sendReminder(String userId, String message) async {
    try {
      final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      final token = doc.data()?['fcmToken'];

      if (token != null && token.isNotEmpty) {
        // In real apps, use Firebase Cloud Functions or external API
        debugPrint('Mock sending message to $token: $message');
      } else {
        debugPrint('User $userId has no FCM token.');
      }
    } catch (e) {
      debugPrint('Error sending reminder: $e');
    }
  }
}

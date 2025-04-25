// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:workmanager/workmanager.dart';
// import '../models/payment.dart';
//
// class ReminderService {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> initialize() async {
//     await _messaging.requestPermission();
//     _setupBackgroundHandler();
//     _scheduleDailyReminders();
//   }
//
//   void _setupBackgroundHandler() {
//     FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
//   }
//
//   static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//     // Handle background notifications
//   }
//
//   void _scheduleDailyReminders() {
//     Workmanager().registerPeriodicTask(
//       "reminders",
//       "sendPaymentReminders",
//       frequency: const Duration(hours: 24),
//     );
//   }
//
//   Future<void> sendReminders() async {
//     final now = DateTime.now();
//     final upcomingPayments = await _firestore.collection('payments')
//         .where('dueDate', isGreaterThanOrEqualTo: now)
//         .where('status', isEqualTo: 'pending')
//         .get();
//
//     for (final doc in upcomingPayments.docs) {
//       final payment = Payment.fromMap(doc.data());
//       await _sendReminder(payment);
//     }
//   }
//
//   Future<void> _sendReminder(Payment payment) async {
//     final userDoc = await _firestore.collection('users').doc(payment.id).get();
//     final token = userDoc.data()?['fcmToken'];
//
//     if (token != null) {
//       await _messaging.sendMessage(
//         to: token,
//         data: {
//           'title': 'Payment Reminder',
//           'body': 'Your payment of ${payment.amount} is due on ${payment.date}',
//         },
//       );
//     }
//   }
// }
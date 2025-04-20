import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thread-safe payment submission
  Future<void> submitPayment({
    required String userId,
    required double amount,
    required String method,
  }) async {
    await _firestore.runTransaction((transaction) async {
      final docRef = _firestore.collection('payments').doc();
      transaction.set(docRef, {
        'userId': userId,
        'amount': amount,
        'method': method,
        'status': 'completed',
        'date': FieldValue.serverTimestamp(),
      });
    });
  }

  // Fetch payments for a user (concurrent-safe)
  Future<List<Map<String, dynamic>>> getPayments(String userId) async {
    final snapshot = await _firestore
        .collection('payments')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
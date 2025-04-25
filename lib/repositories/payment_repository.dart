import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thread-safe payment submission
  Future<void> submitPayment({
    required String userId,
    required double amount,
    required String method,
    required String studentName,
    required String className,
  }) async {
    await _firestore.runTransaction((transaction) async {
      final docRef = _firestore.collection('payments').doc();
      transaction.set(docRef, {
        'userId': userId,
        'amount': amount,
        'method': method,
        'status': 'completed',
        'studentName': studentName,
        'className': className,
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
  // Add new method for admin to view all payments
  // Add new method for admin to view all payments
  Future<List<Map<String, dynamic>>> getAllPayments({
    String? className,
    String? studentName,
  }) async {
    Query query = _firestore.collection('payments').orderBy('date', descending: true);

    if (className != null) {
      query = query.where('className', isEqualTo: className);
    }

    if (studentName != null) {
      query = query.where('studentName', isEqualTo: studentName);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}


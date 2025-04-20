import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String id;
  final double amount;
  final DateTime date;
  final String status; // e.g., "pending", "completed"

  Payment({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
  });

  /// Factory constructor to safely handle Timestamp
  factory Payment.fromMap(Map<String, dynamic> data) {
    return Payment(
      id: data['id'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      date: _convertToDateTime(data['date']),
      status: data['status'] ?? 'pending',
    );
  }

  /// Converts Timestamp or DateTime into DateTime safely
  static DateTime _convertToDateTime(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    } else if (date is DateTime) {
      return date;
    } else {
      throw FormatException('Invalid date format: $date');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'status': status,
    };
  }
}

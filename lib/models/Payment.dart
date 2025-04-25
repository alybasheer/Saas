import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String id;
  final String userId; // Added for user association
  final String feeStructureId; // Added for fee structure reference
  final double amount;
  final DateTime date;
  final DateTime dueDate; // Added for reminders
  final String status; // "pending", "completed", "failed"
  final String method; // "credit_card", "bank_transfer", etc.
  final String? receiptUrl; // Added for receipt storage
  final String? transactionId;
  final String studentName;
  final String className;// Added for payment gateway reference

  Payment({
    required this.id,
    required this.userId,
    required this.feeStructureId,
    required this.amount,
    required this.date,
    required this.dueDate,
    this.status = 'pending',
    required this.method,
    this.receiptUrl,
    this.transactionId,
    required this.className,
    required this.studentName,
  });

  factory Payment.fromMap(Map<String, dynamic> data) {
    return Payment(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      feeStructureId: data['feeStructureId'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      date: _convertToDateTime(data['date']),
      dueDate: _convertToDateTime(data['dueDate']),
      status: data['status'] ?? 'pending',
      method: data['method'] ?? 'unknown',
      receiptUrl: data['receiptUrl'],
      transactionId: data['transactionId'],
      studentName: data['studentName'] ?? '',
      className: data['className'] ?? '',
    );
  }

  static DateTime _convertToDateTime(dynamic date) {
    if (date is Timestamp) return date.toDate();
    if (date is DateTime) return date;
    throw FormatException('Invalid date format: $date');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'feeStructureId': feeStructureId,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'dueDate': Timestamp.fromDate(dueDate),
      'status': status,
      'method': method,
      if (receiptUrl != null) 'receiptUrl': receiptUrl,
      if (transactionId != null) 'transactionId': transactionId,
      'studentName': studentName,
      'className': className,
    };
  }

  Payment copyWith({
    String? id,
    String? userId,
    String? feeStructureId,
    double? amount,
    DateTime? date,
    DateTime? dueDate,
    String? status,
    String? method,
    String? receiptUrl,
    String? transactionId,
    String? studentName,
    String? className,
  }) {
    return Payment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      feeStructureId: feeStructureId ?? this.feeStructureId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      method: method ?? this.method,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      transactionId: transactionId ?? this.transactionId,
      studentName: studentName ?? this.studentName,
        className: className ?? this.className,
    );
  }
}
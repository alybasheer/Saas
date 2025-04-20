import 'package:cloud_firestore/cloud_firestore.dart';

class FeeStructure {
  final String id;
  final String name;
  final double amount;
  final DateTime dueDate;

  FeeStructure({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
  });

  factory FeeStructure.fromMap(Map<String, dynamic> data) {
    return FeeStructure(
      id: data['id'],
      name: data['name'],
      amount: (data['amount'] as num).toDouble(),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
    );
  }
}
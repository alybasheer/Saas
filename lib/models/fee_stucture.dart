import 'package:cloud_firestore/cloud_firestore.dart';

class FeeStructure {
  final String id;
  final String name;
  final String description;
  final double amount;
  final DateTime dueDate;
  final List<String> applicableClasses;
  final bool isActive;
  final String feeType; // "Tuition", "Exam", "Transport", etc.
  final String? academicYear;

  FeeStructure({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.applicableClasses,
    this.isActive = true,
    required this.academicYear,
    required this.feeType,
  });

  factory FeeStructure.fromMap(Map<String, dynamic> data) {
    return FeeStructure(
      id: data['id'] ?? '', // Provide empty string as default if null
      name: data['name'] ?? '', // Provide empty string as default if null
      description: data['description'] ?? '', // Provide empty string as default if null
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate()
          : DateTime.now(), // Default to current date if null
      applicableClasses: data['applicableClasses'] != null
          ? List<String>.from(data['applicableClasses'])
          : <String>[], // Default to empty list if null
      isActive: data['isActive'] ?? true, // Default to true if null
      feeType: data['feeType'] ?? 'Tuition', // Default to 'Tuition' if null
      academicYear: data['academicYear'], // Can be null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'dueDate': Timestamp.fromDate(dueDate),
      'applicableClasses': applicableClasses,
      'isActive': isActive,
      'feeType': feeType,
      if(academicYear != null ) 'academicYear' : academicYear,
    };

  }
  String get formattedDueDate =>
      '${dueDate.day}/${dueDate.month}/${dueDate.year}';
}
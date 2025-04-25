import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fee_stucture.dart';

class FeeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all fee structures with optional filters
  Future<List<FeeStructure>> getFeeStructures({
    String? classFilter,
    String? feeTypeFilter,
    bool? activeOnly = true,
  }) async {
    Query query = _firestore.collection('fee_structures');

    if (activeOnly == true) {
      query = query.where('isActive', isEqualTo: true);
    }

    if (classFilter != null) {
      query = query.where('applicableClasses', arrayContains: classFilter);
    }

    if (feeTypeFilter != null) {
      query = query.where('feeType', isEqualTo: feeTypeFilter);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>; // Casting fixed here
      final mapData = <String, dynamic>{'id': doc.id};
      mapData.addAll(data);
      return FeeStructure.fromMap(mapData);
    }).toList();
  }

  // Add a new fee structure
  Future<void> addFeeStructure(FeeStructure fee) async {
    await _firestore.collection('fee_structures').add(fee.toMap());
  }

  // Update an existing fee structure
  Future<void> updateFeeStructure(String id, Map<String, dynamic> updates) async {
    await _firestore.collection('fee_structures').doc(id).update(updates);
  }

  // Toggle active status
  Future<void> toggleFeeStructureStatus(String id, bool isActive) async {
    await _firestore.collection('fee_structures').doc(id).update({
      'isActive': isActive,
    });
  }
}

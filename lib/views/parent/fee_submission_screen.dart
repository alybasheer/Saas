import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:saas_project/views/parent/payment_history_screen.dart';

import '../../controllers/PaymentController.dart';

class FeeSubmissionScreen extends StatefulWidget {
  const FeeSubmissionScreen({super.key});

  @override
  State<FeeSubmissionScreen> createState() => _FeeSubmissionScreenState();
}

// Update fee_submission_screen.dart
class _FeeSubmissionScreenState extends State<FeeSubmissionScreen> {
  final _amountController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _classNameController = TextEditingController();
  String _selectedMethod = 'JazzCash';

  Future<void> _submitFee() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null ||
        _studentNameController.text.isEmpty ||
        _classNameController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      await Get.find<PaymentController>().submitPayment(
        amount: amount,
        method: _selectedMethod,
        studentName: _studentNameController.text,
        className: _classNameController.text,
      );
      Get.off(() => PaymentHistoryScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fee Submission")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _studentNameController,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _classNameController,
              decoration: const InputDecoration(labelText: 'Class Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedMethod,
              items: ['JazzCash', 'Cash', 'Bank Transfer'].map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMethod = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFee,
              child: const Text('Submit Fee'),
            ),
          ],
        ),
      ),
    );
  }
}
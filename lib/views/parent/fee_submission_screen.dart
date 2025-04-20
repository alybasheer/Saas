import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:saas_project/views/parent/payment_history_screen.dart';

class FeeSubmissionScreen extends StatefulWidget {
  const FeeSubmissionScreen({super.key});

  @override
  State<FeeSubmissionScreen> createState() => _FeeSubmissionScreenState();
}

class _FeeSubmissionScreenState extends State<FeeSubmissionScreen> {
  final _amountController = TextEditingController();
  String _selectedMethod = 'JazzCash';

  Future<void> _submitFee() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) return;

    final paymentData = {
      'amount': amount,
      'date': DateTime.now(),
      'method': _selectedMethod,
      'status': 'Success',
    };

    await FirebaseFirestore.instance.collection('payments').add(paymentData);
    Get.to(PaymentHistoryScreen);

    Get.snackbar('Success', 'Fee submitted successfully!');
    // Navigate to history screen
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
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedMethod,
              items: ['JazzCash', 'Cash', 'Bank Transfer'].map((method) {
                return DropdownMenuItem(value: method, child: Text(method));
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

// Create admin_fee_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/PaymentController.dart';

class AdminFeeReportsScreen extends StatefulWidget {
  const AdminFeeReportsScreen({super.key});

  @override
  State<AdminFeeReportsScreen> createState() => _AdminFeeReportsScreenState();
}

class _AdminFeeReportsScreenState extends State<AdminFeeReportsScreen> {
  final PaymentController _paymentController = Get.find<PaymentController>();
  final TextEditingController _classFilterController = TextEditingController();
  final TextEditingController _studentFilterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _paymentController.fetchAllPayments();
  }

  void _applyFilters() {
    _paymentController.fetchAllPayments(
      className: _classFilterController.text.isEmpty ? null : _classFilterController.text,
      studentName: _studentFilterController.text.isEmpty ? null : _studentFilterController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _applyFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _classFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Class',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _studentFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Student',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_paymentController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: _paymentController.payments.length,
                itemBuilder: (context, index) {
                  final payment = _paymentController.payments[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('${payment['studentName']} (${payment['className']})'),
                      subtitle: Text(
                        'Amount: ${payment['amount']} PKR\n'
                            'Method: ${payment['method']}\n'
                            'Date: ${payment['date'].toDate()}',
                      ),
                      trailing: Text(
                        payment['status'],
                        style: TextStyle(
                          color: payment['status'] == 'completed'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
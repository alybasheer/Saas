import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeeStructureScreen extends StatelessWidget {
  FeeStructureScreen({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Structure'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Fee Structure',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Below is the fee structure for your courses. Please make sure to pay your fees before the due date.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            // Fetching and displaying the data from Firestore
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: _firestore.collection('feeStructure').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final feeList = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: feeList.length,
                    itemBuilder: (context, index) {
                      final fee = feeList[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            fee['course'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Amount: ${fee['amount']}\nDue Date: ${fee['dueDate']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          trailing: Text(
                            fee['status'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: fee['status'] == 'Paid'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

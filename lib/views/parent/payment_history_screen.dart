import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No payment history found.'));
          }

          final history = snapshot.data!.docs;

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final data = history[index].data() as Map<String, dynamic>;
              final date = (data['date'] as Timestamp).toDate();
              final amount = data['amount'];
              final method = data['method'] ?? 'Unknown';
              final status = data['status'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Amount: ${amount.toString()} PKR'),
                  subtitle: Text(
                    'Date: ${date.day}-${_monthName(date.month)}-${date.year}\nMethod: $method',
                  ),
                  trailing: Icon(
                    status == 'Success' ? Icons.check_circle : Icons.info,
                    color: status == 'Success' ? Colors.green : Colors.orange,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }
}

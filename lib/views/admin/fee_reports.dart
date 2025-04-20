import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeeReportsScreen extends StatelessWidget {
  const FeeReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fee Reports"),
        centerTitle: true, // Centering the title
        backgroundColor: Colors.blueAccent, // Custom background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Heading and Description
            const Text(
              "Fee Reports Overview",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "This screen displays a list of all payment transactions. You can view details like the amount, payment status, and date of each payment.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // FutureBuilder for fetching payment data
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('payments').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());

                  final payments = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final data =
                          payments[index].data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            "Amount: ${data['amount']}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "Status: ${data['status']} | Date: ${data['date'].toDate()}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.blueAccent,
                          ),
                          onTap: () {
                            // Optionally add any action on tap, such as navigating to detailed view
                          },
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

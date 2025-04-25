import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saas_project/controllers/auth_controller.dart';
import 'package:saas_project/views/parent/payment_history_screen.dart';
import 'fee_submission_screen.dart';

class ParentDashboard extends StatelessWidget {
   ParentDashboard({super.key});
   AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Dashboard"),
        actions: [
      IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        await authController.signOut();// Call signOut
        Get.offAllNamed('/');  // Redirect to login screen
      },)
        ],
        centerTitle: true, // Centering the app bar title
        backgroundColor: Colors.blueAccent, // Custom background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // Welcome message
            const Text(
              "Welcome to your Dashboard",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),

            // Description/Guide for Parents
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "As a parent, you can easily manage fee submissions and track payment history through this dashboard. Use the buttons below to navigate to the respective sections and keep track of your child's payments. If you have any questions, visit our support section for further assistance.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Fees Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeeSubmissionScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text("Submit Fees"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.green, // Button color
              ),
            ),
            const SizedBox(height: 20),

            // View Payment History Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentHistoryScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text("View Payment History"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.orange, // Button color
              ),
            ),
            const Spacer(),

            // Footer message
            const Text(
              "For more options, visit our support section.",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

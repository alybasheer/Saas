import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saas_project/controllers/auth_controller.dart';
import 'AdminFeeReportsScreen.dart';
import 'fee_reports.dart';
import 'fee_stucture_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true, // Centering the app bar title
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.signOut();// Call signOut
              Get.offAllNamed('/');  // Redirect to login screen
            },)
        ],// Custom background color
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
              "Admin Dashboard",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),

            // Description/Guide for Admin
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "As an admin, you can generate fee reports and manage the fee structure through this dashboard. Use the options below to navigate to the relevant section. Please ensure all data is up to date.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Generate Reports Button
            // Update admin_dashboard.dart
// Change the Generate Reports button to:
            ElevatedButton.icon(
              onPressed: () {
                Get.to(() => const AdminFeeReportsScreen());
              },
              icon: const Icon(Icons.report),
              label: const Text("Generate Reports"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // Manage Fee Structure Button
            // In admin_dashboard.dart, update the Manage Fee Structure button:
            ElevatedButton.icon(
              onPressed: () {
                Get.to(() => FeeStructureScreen());
              },
              icon: const Icon(Icons.settings),
              label: const Text("Manage Fee Structure"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.orange,
              ),
            ),
            const Spacer(),

            // Footer message
            const Text(
              "For more assistance, visit our support section.",
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

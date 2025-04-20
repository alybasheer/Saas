import 'package:flutter/material.dart';
import 'fee_reports.dart';
import 'fee_stucture_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
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
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FeeReportsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.report),
              label: const Text("Generate Reports"),
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

            // Manage Fee Structure Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeeStructureScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
              label: const Text("Manage Fee Structure"),
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

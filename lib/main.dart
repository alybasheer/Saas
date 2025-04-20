import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saas_project/views/admin/fee_stucture_screen.dart';
import 'package:saas_project/views/parent/ParentDashboard.dart';
import 'AuthService.dart';
import 'views/admin/admin_dashboard.dart';
import 'views/admin/fee_reports.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';
import 'views/parent/fee_submission_screen.dart';
import 'views/parent/payment_history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.put(AuthService());

    // Observe auth state
    ever<User?>(authService.firebaseUser, (user) {
      if (user == null) {
        Get.offAll(() => SignupScreen());
      } else {
        Get.offAll(() => authService.userRole.value == 'admin'
            ? const AdminDashboard()
            : const ParentDashboard());
      }
    });

    return GetMaterialApp(
        title: 'School Fee System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        getPages: [
          GetPage(name: '/', page: () => LoginScreen()),
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/signup', page: () => SignupScreen()),

          // Admin routes
          GetPage(name: '/admin/dashboard', page: () => const AdminDashboard()),
          GetPage(name: '/admin/reports', page: () => const FeeReportsScreen()),
          GetPage(
              name: '/admin/fee-structure', page: () => FeeStructureScreen()),

          // Parent routes
          GetPage(
              name: '/parent/dashboard', page: () => const ParentDashboard()),
          GetPage(
              name: '/parent/submit-fee',
              page: () => const FeeSubmissionScreen()),
          GetPage(
              name: '/parent/payment-history',
              page: () => const PaymentHistoryScreen()),
        ],
        home: const ParentDashboard()
        //  Obx(() {
        //   if (authService.isLoading.value) {
        //     return const Scaffold(
        //       body: Center(child: CircularProgressIndicator()),
        //     );
        //   }
        //   return authService.firebaseUser.value == null
        //       ? LoginScreen()
        //       : authService.userRole.value == 'admin'
        //       ? const AdminDashboard()
        //       : const ParentDashboard();
        // }),
        );
  }
}

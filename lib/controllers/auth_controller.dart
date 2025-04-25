import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<User?> user = (null as User?).obs;
  final RxString userRole = ''.obs;
  final RxBool isLoading = false.obs;

  // List of authorized admin emails
  final List<String> _adminEmails = [
    'admin@school.com',
    'principal@school.com'
  ];

  @override
  void onInit() {
    _auth.authStateChanges().listen((user) {
      this.user.value = user;
      if (user != null) _fetchUserRole(user.uid);
    });
    super.onInit();
  }

  /// Fetch user role from Firestore
  Future<void> _fetchUserRole(String uid) async {
    if (userRole.value.isNotEmpty) return;
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      userRole.value = doc.data()?['role'] ?? '';
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user role",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Sign up user with admin email validation
  Future<void> signUp(String email, String password, String name, String role) async {
    try {
      isLoading.value = true;

      // Validate admin registration
      if (role == 'admin' && !_isAdminEmail(email)) {
        throw Exception('Admin registration requires authorized email');
      }

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Force correct role based on email
      final actualRole = _isAdminEmail(email) ? 'admin' : role;

      await _firestore.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'role': actualRole,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Auto-login after signup
      await signIn(email, password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Signup Failed", e.message ?? "Unknown error",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Log in user with role verification
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verify role consistency for admin emails
      if (_isAdminEmail(email)) {
        final doc = await _firestore.collection('users').doc(cred.user!.uid).get();
        if (doc.data()?['role'] != 'admin') {
          await _auth.signOut();
          throw Exception('This email requires admin privileges');
        }
      }

      // Wait for role to be fetched
      await _fetchUserRole(cred.user!.uid);

      // Role-based navigation
      _redirectBasedOnRole();

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Unknown error",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper method to check admin emails
  bool _isAdminEmail(String email) {
    return _adminEmails.contains(email);
  }

  /// Role-based redirection
  void _redirectBasedOnRole() {
    if (userRole.value == 'admin') {
      Get.offAllNamed('/admin/dashboard');
    } else {
      Get.offAllNamed('/parent/dashboard');
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _auth.signOut();
      userRole.value = '';
      Get.offAllNamed('/');
    } catch (e) {
      Get.snackbar("Error", "Failed to sign out: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
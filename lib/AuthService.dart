import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxString userRole = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  /// Handle authentication state change
  void _handleAuthChanged(User? user) async {
    if (user != null) {
      isLoading.value = true;
      // Move heavy firestore calls to background
      await _fetchUserRole(user.uid);
    } else {
      userRole.value = ''; // Clear user role if not authenticated
    }
  }

  /// Fetch user role (moved to a background task)
  Future<void> _fetchUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      userRole.value = doc.data()?['role'] ?? '';
    } catch (e) {
      userRole.value = ''; // In case of error, reset role
      debugPrint('Error fetching user role: $e');
    } finally {
      isLoading.value = false; // Stop loading after data is fetched
    }
  }

  /// Sign-in method with enhanced error handling
  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Authentication failed');
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign-up method with user creation and role assignment
  Future<void> signUp(String email, String password, String name,String role) async {
    isLoading.value = true;
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(cred.user?.uid).set({
        'name': name,
        'email': email,
        'role': role, // default role
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Registration failed');
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign-out method to log the user out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

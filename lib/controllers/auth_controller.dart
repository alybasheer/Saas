import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Constants.dart';
import '../repositories/auth_repository.dart';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<User?> user = (null as User?).obs;
  final RxString userRole = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    _auth.authStateChanges().listen((user) {
      this.user.value = user;
      if (user != null) _fetchUserRole(user.uid);
    });
    super.onInit();
  }

  Future<void> _fetchUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    userRole.value = doc.data()?['role'] ?? '';
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      isLoading.value = true;
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'role': 'parent', // Default role
        'createdAt': FieldValue.serverTimestamp(),
      });
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
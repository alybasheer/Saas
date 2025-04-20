import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void _handleAuthChanged(User? user) async {
    if (user != null) {
      isLoading.value = true;
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        userRole.value = doc.data()?['role'] ?? '';
      } catch (e) {
        userRole.value = '';
      } finally {
        isLoading.value = false;
      }
    } else {
      userRole.value = '';
    }
  }

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

  Future<void> signUp(String email, String password, String name) async {
    isLoading.value = true;
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(cred.user?.uid).set({
        'name': name,
        'email': email,
        'role': 'parent', // default role
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Registration failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

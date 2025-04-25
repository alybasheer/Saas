import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email, password, and role
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Ensure that the user is created successfully before writing to Firestore
      if (cred.user != null) {
        await _firestore.collection('users').doc(cred.user?.uid).set({
          'name': name,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        throw Exception('User creation failed');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception("Signup failed: ${e.message}");
    } catch (e) {
      throw Exception("An unknown error occurred during signup: $e");
    }
  }

  // Sign in with email/password
  Future<User?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Login failed: ${e.message}");
    } catch (e) {
      throw Exception("An unknown error occurred during login: $e");
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Sign-out failed: $e");
    }
  }
}

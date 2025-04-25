import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'parent'; // Default role
  final List<String> _roles = ['parent', 'admin']; // Allowed roles

  // List of admin emails (replace with your actual admin emails)
  final List<String> _adminEmails = [
    'admin@school.com',
    'principal@school.com'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo/Header
                  const FlutterLogo(size: 72),
                  const SizedBox(height: 24),
                  const Text(
                    'School Fee System',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (val) => val!.length < 6 ? 'Minimum 6 characters' : null,
                  ),
                  const SizedBox(height: 16),

                  // Role Selection (Dropdown)
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Account Type',
                      prefixIcon: Icon(Icons.people_alt),
                      border: OutlineInputBorder(),
                    ),
                    items: _roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role.capitalizeFirst!),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedRole = value!),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  Obx(() {
                    final authController = Get.find<AuthController>();
                    return authController.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _submitForm,
                        child: const Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // Login Link
                  TextButton(
                    onPressed: () => Get.off(() =>  LoginScreen()),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.grey[700]),
                        children: const [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom email validator (checks admin emails)
  String? _validateEmail(String? val) {
    if (val == null || !val.contains('@')) return 'Invalid email';

    // If selecting admin role, validate against admin emails
    if (_selectedRole == 'admin' && !_adminEmails.contains(val)) {
      return 'Only authorized emails can register as admin';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await Get.find<AuthController>().signUp(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _selectedRole, // Pass selected role
      );
    }
  }
}
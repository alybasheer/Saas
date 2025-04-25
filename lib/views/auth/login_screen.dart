import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas_project/views/auth/signup_screen.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _focusNode = FocusNode();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Center(
                child: Column(
                  children: [
                    FlutterLogo(size: 72),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to manage school fees',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Form Section
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^.+@.+\..+$').hasMatch(val)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (val) =>
                          val!.isEmpty ? 'Please enter your password' : null,
                          onFieldSubmitted: (_) => _login(),
                        ),
                        const SizedBox(height: 8),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement password reset
                            },
                            child: Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Login Button
                        Obx(() {
                          final authController = Get.find<AuthController>();
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: authController.isLoading.value ? null : _login,
                              child: authController.isLoading.value
                                  ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : Text(
                                'SIGN IN',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sign Up Section
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    TextButton(
                      onPressed: () => Get.offAll(() => SignupScreen()),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Unfocus keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      await Get.find<AuthController>().signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }
}
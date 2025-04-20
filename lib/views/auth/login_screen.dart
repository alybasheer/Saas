import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas_project/views/auth/signup_screen.dart';
import '../../../../controllers/auth_controller.dart';
class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 24),
              Obx(() => Get.find<AuthController>().isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              )),
              TextButton(
                onPressed: () => Get.offAll(() => SignupScreen()),
                child: Text('Need an account? Sign up'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      await Get.find<AuthController>().signIn(
        _emailController.text,
        _passwordController.text,
      );
    }
  }
}
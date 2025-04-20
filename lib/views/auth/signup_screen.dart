import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/auth_controller.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Parent/Student Name'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                !val!.contains('@') ? 'Invalid email' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) =>
                val!.length < 6 ? 'Minimum 6 characters' : null,
              ),
              SizedBox(height: 24),
              Obx(() => Get.find<AuthController>().isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Account'),
              )),
              TextButton(
                onPressed: () => Get.to(() => LoginScreen()),
                child: Text('Already have an account? Login'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await Get.find<AuthController>().signUp(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );
    }
  }
}
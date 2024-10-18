import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/widgets/custom_button.dart';
import 'package:grocery_app/widgets/custom_textfiled.dart';
// import 'package:grocery_app/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Validation logic
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'assword must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    'Grocery App',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  const SizedBox(height: 100),
                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        'New here?',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          // Navigate to sign up screen
                        },
                        child: const Text(
                          'Create account',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  CustomTextfield(
                    controller: _emailController,
                    text: 'Email Address',
                    icon: const Icon(Icons.alternate_email),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 20),
                  CustomTextfield(
                    controller: _passwordController,
                    text: 'Password',
                    icon: const Icon(Icons.lock_outline),
                    isObscured: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Handle forgot password
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        // Handle login logic
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'or login with',
                      style: TextStyle(color: Colors.grey.shade500),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/services/auth/auth_services.dart';
import 'package:grocery_app/widgets/custom_button.dart';
import 'package:grocery_app/widgets/custom_textfiled.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTap;

  const RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final authServices = AuthServices();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reenterPasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isLoading = true);
    try {
      final response = await authServices.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (response?.session != null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(); // Redirect to the previous screen or login
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Validation functions
  String? _validateName(String? value) {
    return (value == null || value.isEmpty)
        ? 'Please enter your full name'
        : null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your phone number';
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateReenterPassword(String? value) {
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                const SizedBox(height: 30),
                Text(
                  'Welcome!',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  controller: _nameController,
                  text: 'Full Name',
                  icon: const Icon(Icons.person_outline),
                  validator: _validateName,
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  controller: _emailController,
                  text: 'Email Address',
                  icon: const Icon(Icons.alternate_email),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  controller: _phoneController,
                  text: 'Phone Number',
                  icon: const Icon(Icons.phone_outlined),
                  validator: _validatePhone,
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  controller: _passwordController,
                  text: 'Password',
                  icon: const Icon(Icons.lock_outline),
                  isObscured: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  controller: _reenterPasswordController,
                  text: 'Re-enter Password',
                  icon: const Icon(Icons.lock_outline),
                  isObscured: true,
                  validator: _validateReenterPassword,
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: widget.onTap,
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: CustomButton(
                                text: 'Sign Up',
                                onPressed: _signUp,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _reenterPasswordController.dispose();
    super.dispose();
  }
}

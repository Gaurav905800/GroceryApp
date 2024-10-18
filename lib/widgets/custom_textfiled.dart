import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String text;
  final Widget? icon;
  final bool isObscured; // For password fields
  final TextEditingController? controller;
  final String? Function(String?)? validator; // For validation

  const CustomTextfield({
    super.key,
    required this.text,
    this.icon,
    this.isObscured = false,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isObscured, // Hide text for password input
        decoration: InputDecoration(
          hintText: text,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          prefixIcon: icon,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        validator: validator, // Apply validation
      ),
    );
  }
}

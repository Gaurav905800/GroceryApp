import 'package:flutter/material.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;

  const OtpInputField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60, // Set the width for the square shape
      height: 60, // Set the height for the square shape
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Grey shade 200 background
        borderRadius:
            BorderRadius.circular(8), // Optional: for slight rounded corners
        // border: Border.all(color: Colors.grey), // Border color
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1, // Limit to one digit per field
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
          border: InputBorder.none, // Remove the default border
          counterText: "", // Hide the counter text
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(10),
      child: Image.asset(image),
    );
  }
}

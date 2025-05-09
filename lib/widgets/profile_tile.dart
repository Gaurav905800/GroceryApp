import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected; // Added to track the selected state
  final VoidCallback onTap; // Callback to handle selection

  const ProfileTile({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap to toggle selection
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff03071e) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          // border: Border.all(
          //   color: isSelected ? Colors.transparent : const Color(0xff03071e),
          //   width: 1,
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xff03071e),
              ),
              const SizedBox(width: 20),
              Text(
                text,
                style: GoogleFonts.lexend(
                  color: isSelected ? Colors.white : const Color(0xff03071e),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

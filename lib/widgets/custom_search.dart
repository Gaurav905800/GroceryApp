import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/pages/search_screen.dart';

class CustomSearch extends StatelessWidget {
  final void Function()? onTap;

  const CustomSearch({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Search',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            const Icon(Icons.close, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

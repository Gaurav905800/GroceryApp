import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/pages/bag_screen.dart';
import 'package:grocery_app/pages/favorites_screen.dart';
import 'package:grocery_app/pages/home_screen.dart';
import 'package:grocery_app/state/provider.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/state/favorite_provider.dart';

class AllTabs extends StatefulWidget {
  const AllTabs({super.key});

  @override
  State<AllTabs> createState() => _AllTabsState();
}

class _AllTabsState extends State<AllTabs> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Ensure we're listening to the providers without rebuilding
    Provider.of<FavoriteProvider>(context, listen: false);
    Provider.of<GroceryProvider>(context, listen: false);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          FavoritesScreen(),
          CartScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        currentIndex: _currentIndex,
        selectedLabelStyle: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bag',
          ),
        ],
      ),
    );
  }
}

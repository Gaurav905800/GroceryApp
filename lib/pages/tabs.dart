import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/pages/bag_screen.dart';
import 'package:grocery_app/pages/favorites_screen.dart';
import 'package:grocery_app/pages/home_screen.dart';
import 'package:grocery_app/state/provider.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/state/favorite_provider.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Provider.of<FavoriteProvider>(context);
    Provider.of<GroceryProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          FavoritesScreen(),
          BagScreen(),
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
            _currentIndex = index; // Update the current index when tapped
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

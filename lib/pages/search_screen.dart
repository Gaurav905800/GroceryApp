import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/pages/detail_screen.dart';
import 'package:grocery_app/state/provider.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/models/grocery_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> _hasText = ValueNotifier(false);
  List<Products> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    final groceryProvider =
        Provider.of<GroceryProvider>(context, listen: false);
    _filteredItems = groceryProvider.products;
    _searchController.addListener(() {
      _hasText.value = _searchController.text.isNotEmpty;
    });
  }

  void _filterSearchResults(String query) {
    final groceryProvider =
        Provider.of<GroceryProvider>(context, listen: false);
    List<Products> filtered = groceryProvider.products
        .where((product) =>
            product.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
    setState(() {
      _filteredItems = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _hasText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: TextField(
          controller: _searchController,
          onChanged: _filterSearchResults,
          style: GoogleFonts.poppins(),
          decoration: InputDecoration(
            hintText: 'Search for items...',
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            border: InputBorder.none,
            suffixIcon: ValueListenableBuilder<bool>(
              valueListenable: _hasText,
              builder: (context, hasText, child) {
                return IconButton(
                  icon: Icon(
                    hasText ? Icons.close : Icons.search,
                    color: Colors.grey,
                  ),
                  onPressed: hasText
                      ? () {
                          _searchController.clear();
                          _filterSearchResults('');
                        }
                      : null,
                );
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _filteredItems.isNotEmpty
            ? ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final product = _filteredItems[index];
                  return ListTile(
                    title: Text(
                      product.title ?? 'No Title',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    leading: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.call_made),
                      onPressed: () {
                        _searchController.text = product.title ?? '';
                        _filterSearchResults(_searchController.text);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(product: product),
                        ),
                      );
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  'No results found!',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
                ),
              ),
      ),
    );
  }
}

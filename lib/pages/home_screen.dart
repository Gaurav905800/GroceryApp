import 'package:flutter/material.dart';
import 'package:grocery_app/pages/bag_screen.dart';
import 'package:grocery_app/pages/detail_screen.dart';
import 'package:grocery_app/state/provider.dart';
import 'package:grocery_app/widgets/custom_search.dart';
import 'package:grocery_app/widgets/product_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory = 'All';
  List<int> favoriteIds = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GroceryProvider>(context, listen: false).fetchGroceryData();
    });
  }

  void toggleFavorite(int id) {
    setState(() {
      if (favoriteIds.contains(id)) {
        favoriteIds.remove(id);
      } else {
        favoriteIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            _buildCategoryChips(),
            _buildProductList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      backgroundColor: Colors.grey.shade200,
      expandedHeight: 190.0,
      flexibleSpace: const FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Best Products',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Perfect Choice!',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(height: 15),
              CustomSearch(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<GroceryProvider>(
          builder: (context, groceryProvider, child) {
            if (groceryProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (groceryProvider.groceryData != null &&
                groceryProvider.groceryData!.products != null) {
              var categories = ['All'] +
                  groceryProvider.groceryData!.products!
                      .map((product) => product.category ?? '')
                      .toSet()
                      .toList();

              return SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    var category = categories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (isSelected) {
                          setState(() {
                            selectedCategory = isSelected ? category : 'All';
                          });
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: const Color.fromARGB(255, 135, 35, 28),
                        labelStyle: TextStyle(
                          color: selectedCategory == category
                              ? Colors.white
                              : Colors.black,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        checkmarkColor: Colors.white,
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text('No Categories Available'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Consumer<GroceryProvider>(
      builder: (context, groceryProvider, child) {
        if (groceryProvider.isLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (groceryProvider.groceryData != null &&
            groceryProvider.groceryData!.products != null) {
          var filteredProducts = selectedCategory == 'All'
              ? groceryProvider.groceryData!.products!
              : groceryProvider.groceryData!.products!
                  .where((product) => product.category == selectedCategory)
                  .toList();

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var product = filteredProducts[index];
                return InkWell(
                  child: ProductTile(
                    title: product.title!,
                    description: product.description!,
                    discountedPrice: product.discountPercentage!,
                    price: product.price!,
                    image: product.thumbnail!,
                    id: product.id!,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BagScreen(),
                        ),
                      );
                    },
                    onFavoriteToggled: toggleFavorite,
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
              childCount: filteredProducts.length,
            ),
          );
        } else {
          return const SliverFillRemaining(
            child: Center(child: Text('No Products Available')),
          );
        }
      },
    );
  }
}

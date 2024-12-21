import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/pages/bag_screen.dart';
import 'package:grocery_app/pages/detail_screen.dart';
import 'package:grocery_app/pages/login_screen.dart';
import 'package:grocery_app/services/auth/auth_services.dart';
import 'package:grocery_app/state/provider.dart';
import 'package:grocery_app/widgets/custom_search.dart';
import 'package:grocery_app/widgets/product_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  final List<int> favoriteIds = [];
  bool isDropdownOpen = false;
  final AuthServices authServices = AuthServices();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GroceryProvider>(context, listen: false).fetchGroceryData();
    });
  }

  void _logoutUser(BuildContext context) {
    authServices.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
      snap: true,
      backgroundColor: Colors.grey.shade100,
      expandedHeight: 190.0,
      actions: [
        InkWell(
          onTap: () => setState(() => isDropdownOpen = !isDropdownOpen),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(
                right: 15,
              ),
              child: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ),
        ),
        if (isDropdownOpen) _buildProfileDropdown(),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Best Products',
                    style: GoogleFonts.lexend(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Perfect Choice!',
                style: GoogleFonts.lexend(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 15),
              const CustomSearch(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDropdown() {
    return Positioned(
      top: 70,
      right: 10,
      child: Material(
        elevation: 4,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            setState(() => isDropdownOpen = false);
            _logoutUser(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.logout, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Logout',
                  style: GoogleFonts.lexend(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
            }

            var categories = ['All'] +
                (groceryProvider.groceryData?.products ?? [])
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
                      label: Text(
                        category,
                        style: GoogleFonts.lexend(),
                      ),
                      selected: selectedCategory == category,
                      onSelected: (isSelected) {
                        setState(() {
                          selectedCategory = isSelected ? category : 'All';
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: const Color(0xff87351C),
                      labelStyle: TextStyle(
                        color: selectedCategory == category
                            ? Colors.white
                            : Colors.black,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide.none,
                      ),
                      checkmarkColor: Colors.white,
                    ),
                  );
                },
              ),
            );
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
        }
        var products = groceryProvider.groceryData?.products ?? [];
        var filteredProducts = selectedCategory == 'All'
            ? products
            : products.where((p) => p.category == selectedCategory).toList();

        if (filteredProducts.isEmpty) {
          return SliverFillRemaining(
            child: Center(
                child: Text(
              'No Products Available',
              style: GoogleFonts.lexend(),
            )),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var product = filteredProducts[index];
              return OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                transitionDuration: const Duration(milliseconds: 500),
                openBuilder: (context, _) {
                  return DetailScreen(product: product);
                },
                closedBuilder: (context, openContainer) {
                  return ProductTile(
                    title: product.title!,
                    description: product.description!,
                    discountedPrice: product.discountPercentage!,
                    price: product.price!,
                    image: product.thumbnail!,
                    id: product.id!,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    ),
                    onFavoriteToggled: (id) {
                      setState(() {
                        if (favoriteIds.contains(id)) {
                          favoriteIds.remove(id);
                        } else {
                          favoriteIds.add(id);
                        }
                      });
                    },
                  );
                },
              );
            },
            childCount: filteredProducts.length,
          ),
        );
      },
    );
  }
}

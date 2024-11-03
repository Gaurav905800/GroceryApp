import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/state/provider.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/state/favorite_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final groceryProvider = Provider.of<GroceryProvider>(context);
    final favoriteIds = favoriteProvider.favoriteProducts;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: const Text('Favorites'),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: favoriteIds.isNotEmpty
          ? ListView.builder(
              itemCount: favoriteIds.length,
              itemBuilder: (context, index) {
                int productId = favoriteIds[index];
                var product = groceryProvider.products
                    .firstWhere((p) => p.id == productId, orElse: () => null!);

                // ignore: unnecessary_null_comparison
                if (product != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: Image.network(product.thumbnail!.toString()),
                        title: Text(product.title ?? 'No Title'),
                        subtitle: Text(
                          '\$${product.price}',
                          style: GoogleFonts.lato(
                              fontSize: 16, color: Colors.green.shade600),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            favoriteProvider.toggleFavorite(productId);
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          : Center(
              child: Text(
                'No favorites yet!',
                style: GoogleFonts.lato(
                  fontStyle: FontStyle.italic,
                  fontSize: 26,
                ),
              ),
            ),
    );
  }
}

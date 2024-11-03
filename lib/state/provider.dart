import 'package:flutter/material.dart';
import 'package:grocery_app/models/grocery_model.dart';
import 'package:grocery_app/services/api_services.dart';

class GroceryProvider extends ChangeNotifier {
  GroceryModel? _groceryData;
  bool _isLoading = false;
  final List<Products> _products = []; // List to store fetched products
  final List<Products> _favoriteProducts = [];

  GroceryModel? get groceryData => _groceryData;
  bool get isLoading => _isLoading;
  List<Products> get products => _products; // Expose the product list
  List<Products> get favoriteProducts => _favoriteProducts;

  Future<void> fetchGroceryData() async {
    _isLoading = true;
    notifyListeners();

    GroceryModel? fetchedData = await ApiServices().fetchData();
    if (fetchedData != null) {
      _groceryData = fetchedData;
      _products.clear(); // Clear existing items
      _products.addAll(fetchedData.products ?? []); // Populate with new data
    }
    _isLoading = false;
    notifyListeners();
  }

  // Add a product to favorites
  void addToFavorites(Products product) {
    if (!_favoriteProducts.contains(product)) {
      _favoriteProducts.add(product);
      notifyListeners();
    }
  }

  // Remove a product from favorites
  void removeFromFavorites(Products product) {
    if (_favoriteProducts.contains(product)) {
      _favoriteProducts.remove(product);
      notifyListeners();
    }
  }

  // Check if a product is in the favorites list
  bool isFavorite(Products product) {
    return _favoriteProducts.contains(product);
  }
}

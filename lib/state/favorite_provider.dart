import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<int> _favoriteProductIds = [];

  List<int> get favoriteProducts => _favoriteProductIds;

  void toggleFavorite(int productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners(); // Notify listeners to rebuild UI
  }

  bool isFavorite(int productId) {
    return _favoriteProductIds.contains(productId);
  }
}

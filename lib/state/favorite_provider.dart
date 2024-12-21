import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<int> _favoriteProductIds = [];

  List<int> get favoriteProducts => _favoriteProductIds;

  void toggleFavorite(int productId, BuildContext context) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from favorites'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 500),
        ),
      );
    } else {
      _favoriteProductIds.add(productId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to favorites'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 500),
        ),
      );
    }
    notifyListeners();
  }

  bool isFavorite(int productId) {
    return _favoriteProductIds.contains(productId);
  }
}

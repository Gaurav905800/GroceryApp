import 'package:flutter/material.dart';
import 'package:grocery_app/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    final existingIndex =
        _items.indexWhere((cartItem) => cartItem.id == item.id);
    if (existingIndex != -1) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(int id, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<Product, int> _items = {};

  Map<Product, int> get items => _items;
  int get totalItems =>
      _items.values.fold(0, (sum, quantity) => sum + quantity);
  double get totalPrice {
    double total = 0.0;
    _items.forEach((product, quantity) {
      total += product.price * quantity;
    });
    return total;
  }

  void addToCart(Product product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

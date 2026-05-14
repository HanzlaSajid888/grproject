import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final String? userId;
  List<CartItem> _items = [];
  StreamSubscription<DatabaseEvent>? _cartSubscription;

  CartProvider(this.userId) {
    if (userId != null) {
      _listenToFirebaseCart();
    }
  }

  List<CartItem> get items => _items;

  // For retaining items during AuthProvider rebuilds
  List<CartItem> get currentItems => _items;
  void setItems(List<CartItem> previousItems) {
    if (userId == null) {
      _items = previousItems;
      notifyListeners();
    }
  }

  void _listenToFirebaseCart() {
    final ref = FirebaseDatabase.instance.ref().child('users/$userId/cart');
    _cartSubscription = ref.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _items = [];
        notifyListeners();
        return;
      }

      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<CartItem> loadedItems = [];

      data.forEach((key, value) {
        // value is a map with product details and quantity
        final prodData = value['product'] as Map<dynamic, dynamic>;
        
        final product = Product(
          id: prodData['id'] ?? '',
          name: prodData['name'] ?? '',
          price: (prodData['price'] ?? 0).toDouble(),
          imageUrl: prodData['imageUrl'] ?? '',
          category: prodData['category'] ?? '',
        );

        loadedItems.add(CartItem(
          product: product,
          quantity: value['quantity'] ?? 1,
        ));
      });

      _items = loadedItems;
      notifyListeners();
    });
  }

  void _syncWithFirebase() {
    if (userId == null) return;
    
    final ref = FirebaseDatabase.instance.ref().child('users/$userId/cart');
    final Map<String, dynamic> cartData = {};
    
    for (var item in _items) {
      cartData[item.product.id] = {
        'product': item.product.toMap(),
        'quantity': item.quantity,
      };
    }
    
    ref.set(cartData);
  }

  void addToCart(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(product: product));
    }
    _syncWithFirebase();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _syncWithFirebase();
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity += 1;
      _syncWithFirebase();
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      _syncWithFirebase();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _syncWithFirebase();
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }
}

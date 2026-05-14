import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/product.dart';
import '../data/dummy_data.dart'; // Keep temporarily for upload method

class ProductProvider with ChangeNotifier {
  List<Product> _watches = [];
  List<Product> _electronics = [];
  List<Product> _footwear = [];
  List<Product> _newArrivals = [];
  List<Product> _allProducts = [];

  bool _isLoading = false;

  List<Product> get watches => _watches;
  List<Product> get electronics => _electronics;
  List<Product> get footwear => _footwear;
  List<Product> get newArrivals => _newArrivals;
  List<Product> get allProducts => _allProducts;
  bool get isLoading => _isLoading;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('products');

  ProductProvider() {
    _fetchProducts();
  }

  Future<void> uploadDummyDataToRTDB() async {
    _isLoading = true;
    notifyListeners();
    
    final allDummies = [
      ...dummyWatches,
      ...dummyElectronics,
      ...dummyFootwear,
      ...dummyNewArrivals,
    ];

    // Upload each product to Firebase Realtime Database
    for (var product in allDummies) {
      await _dbRef.child(product.id).set(product.toMap());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value;
      
      _watches = [];
      _electronics = [];
      _footwear = [];
      _newArrivals = [];
      _allProducts = [];

      if (data != null && data is Map) {
        data.forEach((key, value) {
          final product = Product.fromRTDB(value as Map<dynamic, dynamic>);
          _allProducts.add(product);
          
          final cat = product.category.toLowerCase();
          if (cat == 'watches') _watches.add(product);
          if (cat == 'electronics') _electronics.add(product);
          if (cat == 'footwear') _footwear.add(product);
        });
        
        // Let's just consider the first 5 products as new arrivals for demo
        if (_allProducts.length > 5) {
          _newArrivals = _allProducts.sublist(0, 5);
        } else {
          _newArrivals = List.from(_allProducts);
        }
      }

      _isLoading = false;
      notifyListeners();
    });
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return _allProducts.where((p) => p.name.toLowerCase().contains(lowerQuery) || p.category.toLowerCase().contains(lowerQuery)).toList();
  }
}

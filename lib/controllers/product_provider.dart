import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _favorites = [];
 Map<Product, int> _cart = {}; 

  String _searchQuery = '';

  bool _isLoading = false;
  bool _isPaginating = false;
  String _errorMessage = '';
  int _page = 1;
  final int _limit = 10;
  final ApiService _apiService = ApiService();

 List<Product> get products =>
      _searchQuery.isEmpty ? _products : filteredProducts;

  List<Product> get favorites => _favorites;
Map<Product, int> get cart => _cart;
  bool get isLoading => _isLoading;
  bool get isPaginating => _isPaginating;
  String get errorMessage => _errorMessage;

bool isFavorite(Product product) {
    return favorites.contains(product);
  }
  List<Product> get popularProducts =>
      _products.where((p) => p.id < 10).toList();
Future<void> fetchProducts({bool loadMore = false}) async {
    if (loadMore) {
      _isPaginating = true;
    } else {
      _isLoading = true;
      _products.clear();
      _page = 1;
    }
    notifyListeners();

    try {
      List<Product> newProducts =
          await _apiService.fetchProducts(page: _page, limit: _limit);

      if (newProducts.isEmpty) {
        print("No new products fetched, stopping pagination.");
        _isPaginating = false;
        _isLoading = false;
        notifyListeners();
        return;
      }

      _products.addAll(newProducts);
      _page++; 
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    _isPaginating = false;
    notifyListeners();
  }
 void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }
  String get searchQuery => _searchQuery;
  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products
        .where((product) =>
            product.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }
  
void addToCart(Product product) {
    if (_cart.containsKey(product)) {
      _cart[product] = _cart[product]! + 1; 
    } else {
      _cart[product] = 1;
    }
    notifyListeners();
  }
  void removeFromCart(Product product) {
    if (_cart.containsKey(product)) {
      if (_cart[product]! > 1) {
        _cart[product] = _cart[product]! - 1; 
      } else {
        _cart.remove(product); 
      }
      notifyListeners();
    }
  }

  
  int getProductQuantity(Product product) {
    return _cart[product] ?? 0;
  }
void clearProducts() {
    _products = [];
    notifyListeners();
  }
 
}

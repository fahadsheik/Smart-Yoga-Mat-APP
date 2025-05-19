import 'package:flutter/material.dart';
import 'package:dealsdray_app/models/product_model.dart';
import 'package:dealsdray_app/utils/api_service.dart';
import 'package:dealsdray_app/utils/constants.dart';

enum ProductsStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  ProductsStatus _status = ProductsStatus.initial;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  List<String> _banners = [];
  String? _errorMessage;
  String _searchQuery = '';

  ProductsStatus get status => _status;
  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  List<String> get categories => _categories;
  List<String> get banners => _banners;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchProducts() async {
    _status = ProductsStatus.loading;
    notifyListeners();

    final response = await _apiService.get<HomeResponse>(
      ApiConstants.productsEndpoint,
      fromJson: (json) => HomeResponse.fromJson(json['data']),
    );

    if (response.success && response.data != null) {
      final homeData = response.data!;
      _products = homeData.products;
      _filteredProducts = List.from(_products);
      _categories = homeData.categories;
      _banners = homeData.banners;
      _status = ProductsStatus.loaded;
    } else {
      _errorMessage = response.error ?? 'Failed to load products';
      _status = ProductsStatus.error;
    }

    notifyListeners();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void filterByCategory(String category) {
    if (category.isEmpty || category == 'All') {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where((product) => product.categories.contains(category))
          .toList();
    }
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    final index = _products.indexWhere((product) => product.id == productId);
    if (index >= 0) {
      final product = _products[index];
      _products[index] = product.copyWith(isFavorite: !product.isFavorite);
      
      // Update in filtered list as well
      final filteredIndex = _filteredProducts.indexWhere((product) => product.id == productId);
      if (filteredIndex >= 0) {
        _filteredProducts[filteredIndex] = _filteredProducts[filteredIndex].copyWith(
          isFavorite: !_filteredProducts[filteredIndex].isFavorite,
        );
      }
      
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
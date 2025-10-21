import 'package:flutter/material.dart';

import '../models/product.dart';
import '../repositories/products_repository.dart';
import '../utils/debouncer.dart';

class ProductsController extends ChangeNotifier {
  ProductsController({required this.repository})
      : _debouncer = Debouncer(),
        _minAvailablePrice = repository.minPrice,
        _maxAvailablePrice = repository.maxPrice,
        _currentMinPrice = repository.minPrice,
        _currentMaxPrice = repository.maxPrice;

  final ProductsRepository repository;
  final Debouncer _debouncer;

  final double _minAvailablePrice;
  final double _maxAvailablePrice;
  double _currentMinPrice;
  double _currentMaxPrice;

  static const int _pageSize = 10;

  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  int _page = 0;
  String _searchTerm = '';
  String _audience = 'All';
  String _category = 'All';
  Set<String> _favoriteIds = <String>{};

  List<Product> _popularProducts = <Product>[];
  List<Product> _gridProducts = <Product>[];

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  List<Product> get popularProducts => _popularProducts;
  List<Product> get gridProducts => _gridProducts;
  String get selectedAudience => _audience;
  String get searchTerm => _searchTerm;
  String get selectedCategory => _category;
  RangeValues get selectedPriceRange => RangeValues(_currentMinPrice, _currentMaxPrice);
  double get minAvailablePrice => _minAvailablePrice;
  double get maxAvailablePrice => _maxAvailablePrice;
  List<String> get categories => <String>{'All', ...repository.categories}.toList();

  Future<void> initialize({Set<String> favoriteIds = const <String>{}}) async {
    _favoriteIds = favoriteIds;
    _isLoading = true;
    notifyListeners();
    await Future.wait([
      _loadPopular(),
      _loadGrid(resetPage: true),
    ]);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadPopular() async {
    final data = await repository.fetchPopular(favoriteIds: _favoriteIds);
    _popularProducts = data;
  }

  Future<void> _loadGrid({bool resetPage = false}) async {
    if (resetPage) {
      _page = 0;
      _hasMore = true;
    }

    final data = await repository.fetchProducts(
      page: _page,
      pageSize: _pageSize,
      favoriteIds: _favoriteIds,
      gender: _audience,
      searchTerm: _searchTerm,
      category: _category,
      minPrice: _currentMinPrice,
      maxPrice: _currentMaxPrice,
    );

    if (resetPage) {
      _gridProducts = data;
    } else {
      _gridProducts = List<Product>.from(_gridProducts)..addAll(data);
    }

    _hasMore = data.length == _pageSize;
    _page = _page + 1;
  }

  Future<void> refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    notifyListeners();
    await _loadPopular();
    await _loadGrid(resetPage: true);
    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();
    await _loadGrid();
    _isLoadingMore = false;
    notifyListeners();
  }

  void setAudience(String audience) {
    if (_audience == audience) return;
    _audience = audience;
    _scheduleRefresh();
    notifyListeners();
  }

  void setCategory(String category) {
    if (_category == category) return;
    _category = category;
    _scheduleRefresh();
    notifyListeners();
  }

  void setSearchTerm(String value) {
    _searchTerm = value;
    _scheduleRefresh();
    notifyListeners();
  }

  void syncFavorites(Set<String> favoriteIds) {
    _favoriteIds = favoriteIds;
    _popularProducts = _popularProducts
        .map((product) => product.copyWith(isFavorite: favoriteIds.contains(product.id)))
        .toList();
    _gridProducts = _gridProducts
        .map((product) => product.copyWith(isFavorite: favoriteIds.contains(product.id)))
        .toList();
    notifyListeners();
  }

  Product? findById(String id) {
    return repository.getById(id, favoriteIds: _favoriteIds);
  }

  Future<void> applyFilters({
    String? gender,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    bool hasChanged = false;

    if (gender != null && _audience != gender) {
      _audience = gender;
      hasChanged = true;
    }

    if (category != null && _category != category) {
      _category = category;
      hasChanged = true;
    }

    if (minPrice != null && maxPrice != null) {
      final clampedMin = minPrice.clamp(_minAvailablePrice, _maxAvailablePrice);
      final clampedMax = maxPrice.clamp(_minAvailablePrice, _maxAvailablePrice);
      if (_currentMinPrice != clampedMin || _currentMaxPrice != clampedMax) {
        _currentMinPrice = clampedMin.toDouble();
        _currentMaxPrice = clampedMax.toDouble();
        hasChanged = true;
      }
    }

    if (!hasChanged) {
      notifyListeners();
      return;
    }

    notifyListeners();
    await refresh();
  }

  Future<void> resetFilters() async {
    _audience = 'All';
    _category = 'All';
    _currentMinPrice = _minAvailablePrice;
    _currentMaxPrice = _maxAvailablePrice;
    notifyListeners();
    await refresh();
  }

  void _scheduleRefresh() {
    _debouncer(() {
      refresh();
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

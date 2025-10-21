import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../repositories/products_repository.dart';
import '../utils/debouncer.dart';

class ProductsController extends ChangeNotifier {
  ProductsController({required this.repository}) : _debouncer = Debouncer();

  final ProductsRepository repository;
  final Debouncer _debouncer;

  static const int _pageSize = 10;

  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  int _page = 0;
  String _searchTerm = '';
  String _audience = 'All';
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
    _debouncer(() {
      refresh();
    });
    notifyListeners();
  }

  void setSearchTerm(String value) {
    _searchTerm = value;
    _debouncer(() {
      refresh();
    });
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

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

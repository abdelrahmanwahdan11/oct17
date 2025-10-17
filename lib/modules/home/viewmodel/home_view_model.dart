import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';
import '../../../data/seed/seed_data.dart';
import '../../../domain/models/listing.dart';
import '../../../domain/repo/listing_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({ListingRepository? repository})
      : _repository = repository ?? SeedListingRepository('assets/seed/listings.json');

  final ListingRepository _repository;

  final List<Listing> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  String _query = '';
  List<String> _filters = [];

  List<Listing> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get query => _query;
  List<String> get filters => List.unmodifiable(_filters);

  Future<void> initialize() async {
    if (_items.isNotEmpty) {
      return;
    }
    await refresh();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    _page = 1;
    _items.clear();
    await _repository.refresh();
    final newItems = await _repository.fetchPage(page: _page, pageSize: 10);
    _items.addAll(newItems);
    _hasMore = newItems.length == 10;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) {
      return;
    }
    _isLoading = true;
    notifyListeners();
    _page += 1;
    final newItems = await _repository.fetchPage(page: _page, pageSize: 10);
    _items.addAll(newItems);
    _hasMore = newItems.length == 10;
    _isLoading = false;
    notifyListeners();
  }

  void updateQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void toggleFilter(String filter) {
    if (_filters.contains(filter)) {
      _filters.remove(filter);
    } else {
      _filters.add(filter);
    }
    notifyListeners();
  }

  Iterable<Listing> filtered(AppLocalizations loc) {
    final code = loc.locale.languageCode;
    return _items.where((listing) {
      final matchesQuery = _query.isEmpty
          ? true
          : listing.titleForLocale(code).toLowerCase().contains(_query.toLowerCase());
      final matchesFilters = _filters.isEmpty ||
          _filters.every((filter) => listing.tags.contains(filter));
      return matchesQuery && matchesFilters;
    });
  }
}

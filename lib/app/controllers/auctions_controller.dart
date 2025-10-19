import 'package:flutter/foundation.dart';

import '../../data/local/auction_repository.dart';
import '../../domain/models/auction.dart';

class AuctionsController extends ChangeNotifier {
  AuctionsController(this._repository);

  final AuctionRepository _repository;
  final List<Auction> _auctions = <Auction>[];
  int _page = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _searchQuery;
  String? _sortKey;

  List<Auction> get auctions => List<Auction>.unmodifiable(_auctions);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get sortKey => _sortKey;
  String? get searchQuery => _searchQuery;

  Future<void> loadInitial() async {
    if (_isLoading) return;
    _page = 0;
    _auctions.clear();
    _hasMore = true;
    await _fetchPage(reset: true);
  }

  Future<void> refresh() async {
    _page = 0;
    _auctions.clear();
    _hasMore = true;
    await _fetchPage(reset: true);
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _page += 1;
    await _fetchPage();
  }

  Future<void> updateSearch(String? query) async {
    _searchQuery = query;
    await loadInitial();
  }

  Future<void> updateSort(String? sortKey) async {
    _sortKey = sortKey;
    await loadInitial();
  }

  Future<Auction> placeBid({
    required String auctionId,
    required double amount,
    double? autoMax,
  }) async {
    final updated = await _repository.placeBid(
      auctionId: auctionId,
      amount: amount,
      autoMax: autoMax,
    );
    final index = _auctions.indexWhere((auction) => auction.id == updated.id);
    if (index != -1) {
      _auctions[index] = updated;
      notifyListeners();
    }
    return updated;
  }

  Future<Auction?> getById(String id) {
    return _repository.getById(id);
  }

  Future<void> _fetchPage({bool reset = false}) async {
    _isLoading = true;
    if (reset) notifyListeners();
    final results = await _repository.fetchAuctions(
      page: _page,
      search: _searchQuery,
      sort: _sortKey,
    );
    if (reset) {
      _auctions
        ..clear()
        ..addAll(results);
    } else {
      _auctions.addAll(results);
    }
    _hasMore = results.isNotEmpty && results.length >= 6;
    _isLoading = false;
    notifyListeners();
  }
}

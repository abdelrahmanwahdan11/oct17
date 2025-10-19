import 'package:flutter/foundation.dart';

import '../../data/local/request_repository.dart';
import '../../domain/models/buy_request.dart';

class RequestsController extends ChangeNotifier {
  RequestsController(this._repository);

  final RequestRepository _repository;
  final List<BuyRequest> _requests = <BuyRequest>[];
  int _page = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _searchQuery;
  String? _sortKey;

  List<BuyRequest> get requests => List<BuyRequest>.unmodifiable(_requests);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> loadInitial() async {
    if (_isLoading) return;
    _page = 0;
    _requests.clear();
    _hasMore = true;
    await _fetchPage(reset: true);
  }

  Future<void> refresh() async {
    _page = 0;
    _requests.clear();
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

  Future<void> _fetchPage({bool reset = false}) async {
    _isLoading = true;
    if (reset) notifyListeners();
    final results = await _repository.fetchRequests(
      page: _page,
      search: _searchQuery,
      sort: _sortKey,
    );
    if (reset) {
      _requests
        ..clear()
        ..addAll(results);
    } else {
      _requests.addAll(results);
    }
    _hasMore = results.isNotEmpty && results.length >= 6;
    _isLoading = false;
    notifyListeners();
  }
}

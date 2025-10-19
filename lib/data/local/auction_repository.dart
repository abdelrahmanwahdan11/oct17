import 'dart:async';

import '../../domain/models/auction.dart';
import '../../domain/models/bid.dart';
import 'seed_data.dart';

class AuctionRepository {
  AuctionRepository() {
    _auctions = decodeSeed(seedAuctionsJson)
        .map((json) => Auction.fromJson(json))
        .toList()
      ..sort((a, b) => a.endAt.compareTo(b.endAt));
  }

  late final List<Auction> _auctions;

  static const _pageSize = 6;

  Future<List<Auction>> fetchAuctions({
    int page = 0,
    String? search,
    String? sort,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    Iterable<Auction> data = _auctions.where((auction) => auction.status == AuctionStatus.live);
    if (search != null && search.trim().isNotEmpty) {
      final query = search.toLowerCase();
      data = data.where((auction) {
        return auction.title.toLowerCase().contains(query) ||
            auction.category.toLowerCase().contains(query);
      });
    }
    if (sort != null) {
      switch (sort) {
        case 'soon':
          data = data.toList()
            ..sort((a, b) => a.endAt.compareTo(b.endAt));
          break;
        case 'recent':
          data = data.toList()
            ..sort((a, b) => b.startPrice.compareTo(a.startPrice));
          break;
        case 'bids':
          data = data.toList()
            ..sort((a, b) => b.currentBid.compareTo(a.currentBid));
          break;
      }
    }
    final list = data.toList();
    final start = page * _pageSize;
    if (start >= list.length) {
      return <Auction>[];
    }
    final end = (start + _pageSize).clamp(0, list.length);
    return list.sublist(start, end);
  }

  Future<Auction?> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _auctions.firstWhere((auction) => auction.id == id, orElse: () => _auctions.first);
  }

  Future<Auction> placeBid({
    required String auctionId,
    required double amount,
    double? autoMax,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final index = _auctions.indexWhere((auction) => auction.id == auctionId);
    if (index == -1) {
      throw StateError('Auction not found');
    }
    final current = _auctions[index];
    if (current.status != AuctionStatus.live || current.endAt.isBefore(DateTime.now())) {
      _auctions[index] = current.copyWith(status: AuctionStatus.ended);
      return _auctions[index];
    }
    final updated = current.copyWith(currentBid: amount);
    var endAt = updated.endAt;
    final remaining = endAt.difference(DateTime.now());
    if (remaining.inSeconds <= 60) {
      endAt = endAt.add(const Duration(seconds: 60));
    }
    _auctions[index] = updated.copyWith(endAt: endAt);
    _bids.add(
      Bid(
        id: 'bid_${_bids.length + 1}',
        auctionId: auctionId,
        userId: 'guest',
        amount: amount,
        autoMax: autoMax,
        createdAt: DateTime.now(),
      ),
    );
    return _auctions[index];
  }

  final List<Bid> _bids = <Bid>[];
}

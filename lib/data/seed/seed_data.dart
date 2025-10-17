import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/listing.dart';
import '../../domain/repo/listing_repository.dart';

class SeedListingRepository implements ListingRepository {
  SeedListingRepository(this.bundlePath);

  final String bundlePath;
  List<Listing>? _cache;

  Future<List<Listing>> _load() async {
    if (_cache != null) {
      return _cache!;
    }
    final jsonString = await rootBundle.loadString(bundlePath);
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    _cache = jsonList
        .map((e) => Listing.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _cache!;
  }

  @override
  Future<List<Listing>> fetchPage({required int page, required int pageSize}) async {
    final data = await _load();
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    if (start >= data.length) {
      return const [];
    }
    return data.sublist(start, end > data.length ? data.length : end);
  }

  @override
  Future<List<Listing>> refresh() async {
    _cache = null;
    return _load();
  }
}

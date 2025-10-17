import '../models/listing.dart';

abstract class ListingRepository {
  Future<List<Listing>> fetchPage({required int page, required int pageSize});
  Future<List<Listing>> refresh();
}

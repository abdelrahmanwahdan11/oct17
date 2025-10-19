import '../../domain/models/buy_request.dart';
import 'seed_data.dart';

class RequestRepository {
  RequestRepository() {
    _requests = decodeSeed(seedRequestsJson)
        .map((json) => BuyRequest.fromJson(json))
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  late final List<BuyRequest> _requests;

  static const _pageSize = 6;

  Future<List<BuyRequest>> fetchRequests({
    int page = 0,
    String? search,
    String? sort,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    Iterable<BuyRequest> data = _requests.where((r) => r.status == RequestStatus.live);
    if (search != null && search.trim().isNotEmpty) {
      final query = search.toLowerCase();
      data = data.where((request) {
        return request.title.toLowerCase().contains(query) ||
            request.category.toLowerCase().contains(query);
      });
    }
    if (sort != null) {
      switch (sort) {
        case 'priority':
          data = data.toList()
            ..sort((a, b) => a.priority.compareTo(b.priority));
          break;
        case 'deadline':
          data = data.toList()
            ..sort((a, b) => a.deadline.compareTo(b.deadline));
          break;
        case 'recent':
          data = data.toList()
            ..sort((a, b) => b.deadline.compareTo(a.deadline));
          break;
      }
    }
    final list = data.toList();
    final start = page * _pageSize;
    if (start >= list.length) {
      return <BuyRequest>[];
    }
    final end = (start + _pageSize).clamp(0, list.length);
    return list.sublist(start, end);
  }
}

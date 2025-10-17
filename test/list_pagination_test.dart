import 'package:flutter_test/flutter_test.dart';

import 'package:app_scaffold/domain/models/listing.dart';
import 'package:app_scaffold/domain/repo/listing_repository.dart';
import 'package:app_scaffold/modules/home/viewmodel/home_view_model.dart';

class _FakeRepo implements ListingRepository {
  _FakeRepo();

  final List<Listing> _data = List.generate(
    25,
    (index) => Listing(
      id: '$index',
      titleAr: 'عنصر $index',
      titleEn: 'Item $index',
      descriptionAr: 'وصف',
      descriptionEn: 'Desc',
      images: const [],
      price: 10,
      rating: 4.5,
      tags: const [],
      gearbox: 'auto',
      fuel: 'ev',
      seats: 4,
    ),
  );

  @override
  Future<List<Listing>> fetchPage({required int page, required int pageSize}) async {
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    if (start >= _data.length) return const [];
    return _data.sublist(start, end > _data.length ? _data.length : end);
  }

  @override
  Future<List<Listing>> refresh() async => _data;
}

void main() {
  test('loads additional pages', () async {
    final vm = HomeViewModel(repository: _FakeRepo());
    await vm.refresh();
    expect(vm.items.length, 10);
    await vm.loadMore();
    expect(vm.items.length, 20);
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:app_scaffold/core/utils/pricing.dart';

void main() {
  test('calculates pricing based on days and unit price', () {
    expect(calculatePrice(days: 3, unitPrice: 100), 300);
    expect(calculatePrice(days: 0, unitPrice: 100), 0);
  });
}

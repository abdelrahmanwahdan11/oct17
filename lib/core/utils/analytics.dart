import 'package:flutter/foundation.dart';

class AnalyticsService {
  const AnalyticsService();

  void log(String event, [Map<String, Object?>? params]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('analytics: $event => $params');
    }
  }
}

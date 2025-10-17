import 'package:flutter/widgets.dart';

import 'app_settings.dart';

class AppSettingsScope extends InheritedNotifier<AppSettings> {
  const AppSettingsScope({super.key, required AppSettings notifier, required Widget child})
      : super(notifier: notifier, child: child);

  static AppSettings of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope not found in context');
    return scope!.notifier!;
  }
}

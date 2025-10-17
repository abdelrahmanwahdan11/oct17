import 'package:flutter/foundation.dart';

class HelpCenterViewModel extends ChangeNotifier {
  final List<Map<String, String>> faqs = const [
    {'question': 'How to change language?', 'answer': 'Open settings and select language.'},
    {'question': 'How to contact support?', 'answer': 'Use the help center form.'},
  ];
}

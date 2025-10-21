import 'package:flutter/material.dart';

double responsivePadding(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1440) return 88;
  if (width >= 1280) return 72;
  if (width >= 1024) return 56;
  if (width >= 840) return 40;
  if (width >= 600) return 28;
  return 16;
}

EdgeInsetsGeometry responsivePagePadding(BuildContext context, {double vertical = 16}) {
  final horizontal = responsivePadding(context);
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}

BoxConstraints responsiveFormConstraints(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final maxWidth = width >= 600 ? 480.0 : double.infinity;
  return BoxConstraints(maxWidth: maxWidth);
}

BoxConstraints responsiveContentConstraints(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  double maxWidth = double.infinity;
  if (width >= 1440) {
    maxWidth = 1180;
  } else if (width >= 1280) {
    maxWidth = 1100;
  } else if (width >= 1024) {
    maxWidth = 960;
  } else if (width >= 840) {
    maxWidth = 780;
  } else if (width >= 600) {
    maxWidth = 560;
  }
  return BoxConstraints(maxWidth: maxWidth);
}

Widget responsiveConstrainedBody(BuildContext context, Widget child) {
  final constraints = responsiveContentConstraints(context);
  return Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: constraints,
      child: SizedBox(width: double.infinity, child: child),
    ),
  );
}

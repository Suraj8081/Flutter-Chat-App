import 'dart:developer' as dev;

import 'package:flutter/material.dart';

void moveTo(BuildContext context, Widget nextScreen,
    {bool clearRoute = false}) {
  dev.log('Navigate to => $nextScreen');
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (ctx) => nextScreen),
    (route) => !clearRoute,
  );
}

ColorScheme getThemeColor(BuildContext context) {
  return Theme.of(context).colorScheme;
}

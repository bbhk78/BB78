import 'package:flutter/material.dart';

import 'package:boysbrigade/constants/data.dart';

const Duration SPLASH_SCREEN_DURATION = Duration(seconds: 2);

// ignore: non_constant_identifier_names
final Map<String, Color> STATUS_COLORS = <String, Color>{
  'present': Colors.green.shade100,
  'late': Colors.blue.shade100,
  'absent': Colors.red.shade100,
  'early': Colors.yellow.shade100,
  'sick': Colors.deepOrange.shade100,
  'late return': Colors.amber.shade100,
  'early leave': Colors.yellow.shade100,
  'personal leave': Colors.teal.shade100,
  'sick leave': Colors.deepOrange.shade100,
  'pe': Colors.purple.shade100,
  'nn': Colors.yellow.shade100,
  'unknown': Colors.grey.shade200,
};

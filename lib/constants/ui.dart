import 'package:flutter/material.dart';

import 'package:boysbrigade/constants/data.dart';

const Duration SPLASH_SCREEN_DURATION = Duration(seconds: 2);

// ignore: non_constant_identifier_names
final Map<String, Color> STATUS_COLORS = <String, Color>{
  'absent': Colors.red.shade100,
  'sick': Colors.orange.shade100,
  'present': Colors.green.shade100,
  'late': Colors.blue.shade100,
  'early': Colors.blue.shade100,
  'pe': Colors.purple.shade100,
  'nn': Colors.yellow.shade100,
  'unknown': Colors.grey.shade200,
  'late return': Colors.orange.shade200,
  'early leave': Colors.orange.shade200,
  'personal leave': Colors.orange.shade200,
  'sick leave': Colors.orange.shade200,
};

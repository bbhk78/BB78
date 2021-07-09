import 'package:flutter/material.dart';

import 'package:boysbrigade/constants/data.dart';

const Duration SPLASH_SCREEN_DURATION = Duration(seconds: 2);

// ignore: non_constant_identifier_names
final Map<String, Color> STATUS_COLORS = <String, Color>{
  AttendanceStatus.absent: Colors.red.shade100,
  AttendanceStatus.sick: Colors.orange.shade100,
  AttendanceStatus.present: Colors.green.shade100,
  AttendanceStatus.late: Colors.blue.shade100,
  AttendanceStatus.unknown: Colors.grey.shade200,
};

// ignore: non_constant_identifier_names
final List<Color> HALF_YEAR_TILE_COLORS = <Color>[
  Colors.red.shade100,
  Colors.orange.shade100,
  Colors.green.shade100,
  Colors.blue.shade100,
];

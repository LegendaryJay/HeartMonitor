import 'dart:ui';

import 'package:flutter/material.dart';

class HeartRateData {
  final int age;

  static final levels = [
    'Resting',
    'Very Light',
    'Light',
    'Moderate',
    'Hard',
    'Maximum',
  ];

  static final colors = [
    Colors.grey[200]!,
    Colors.green[300]!,
    Colors.green[500]!,
    Colors.yellow[700]!,
    Colors.orange[800]!,
    Colors.red[800]!,
  ];

  HeartRateData({required this.age});

  ContextualizedHeartRate getContext(int bpm) {
    final reserveHeartRatePercentage = clampDouble(bpm / (220 - age), 0, 1);
    final levelIndex = (reserveHeartRatePercentage * 6).floor();

    return ContextualizedHeartRate(
      reserveHeartRatePercentage: reserveHeartRatePercentage,
      level: levels[levelIndex],
      color: colors[levelIndex],
    );
  }
}

class ContextualizedHeartRate {
  final double reserveHeartRatePercentage;
  final String level;
  final Color color;

  const ContextualizedHeartRate({
    required this.reserveHeartRatePercentage,
    required this.level,
    required this.color,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BpmGraph extends StatelessWidget {
  final double reserveHeartRatePercentage;

  const BpmGraph({
    Key? key,
    required this.reserveHeartRatePercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: reserveHeartRatePercentage / 100,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
      backgroundColor: Colors.grey[300],
    );
  }
}
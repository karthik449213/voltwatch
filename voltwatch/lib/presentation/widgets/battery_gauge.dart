import 'package:flutter/material.dart';

class BatteryGauge extends StatelessWidget {
  final int percentage;

  const BatteryGauge({
    super.key,
    required this.percentage,
    required this.batteryState,
  });

  Color getColor() {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 40) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0,
              end: percentage / 100,
            ),
            duration: const Duration(milliseconds: 700),
            builder: (context, value, child) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: 12,
              );
            },
          ),
          Text(
            "$percentage%",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
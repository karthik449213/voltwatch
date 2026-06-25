import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
class BatteryGauge extends StatelessWidget {
  final int percentage;
   final BatteryState batteryState;
  const BatteryGauge({
    super.key,
    required this.percentage,
    required this.batteryState,
  });

  // ADDED: Maps current hardware battery state to a functional visual icon
  IconData _getStateIcon() {
    switch (batteryState) {
      case BatteryState.charging:
        return Icons.flash_on;
      case BatteryState.discharging:
        return Icons.battery_charging_full; // Shows standard container frame
      case BatteryState.full:
        return Icons.battery_full;
      case BatteryState.unknown:
      default:
        return Icons.help_outline;
    }
  }

  Color getColor() {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 40) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getColor();

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
                // CHANGED: Binds the tracking color dynamically to the circular progress track
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                backgroundColor: statusColor.withOpacity(0.15),
              );
            },
          ),
          // CHANGED: Position text percentage and explicit state indicator icon cleanly
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$percentage%",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                _getStateIcon(),
                color: statusColor,
                size: 28,
              ),
            ],
          )
        ],
      ),
    );
  }
}
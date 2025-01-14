import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  final String label;
  final int time;
  final int? totalTime;
  final bool isActive;

  const TimeDisplay({
    super.key,
    required this.label,
    required this.time,
    this.totalTime,
    required this.isActive,
  });

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive
            ? Color.fromRGBO(
                primaryColor.r.toInt(),
                primaryColor.g.toInt(),
                primaryColor.b.toInt(),
                0.1,
              )
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? primaryColor
              : Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _formatTime(time),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: primaryColor,
                ),
          ),
          if (totalTime != null) ...[
            const SizedBox(height: 8),
            Text(
              '总计: ${_formatTime(totalTime!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
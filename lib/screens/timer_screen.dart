import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/time_display.dart';
import '../widgets/progress_bar.dart';
import '../widgets/stats_card.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildTargetDurationInput(context, timerProvider),
                    const SizedBox(height: 24),
                    _buildTimeDisplays(context, timerProvider),
                    const SizedBox(height: 24),
                    ProgressBar(
                      progress: timerProvider.progressPercentage,
                    ),
                    const SizedBox(height: 24),
                    _buildControls(context, timerProvider),
                    const SizedBox(height: 24),
                    StatsCard(timerProvider: timerProvider),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '工作休息平衡计时器',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        IconButton(
          icon: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Icon(
                themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
              );
            },
          ),
          onPressed: () {
            context.read<ThemeProvider>().toggleTheme();
          },
        ),
      ],
    );
  }

  Widget _buildTargetDurationInput(BuildContext context, TimerProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '目标时间（分钟）',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '输入目标时间',
          ),
          onChanged: (value) {
            final minutes = int.tryParse(value);
            if (minutes != null && minutes >= 30 && minutes <= 120) {
              provider.setTargetDuration(minutes);
            }
          },
          controller: TextEditingController(
            text: provider.targetDuration.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeDisplays(BuildContext context, TimerProvider provider) {
    return Row(
      children: [
        Expanded(
          child: TimeDisplay(
            label: '工作时间',
            time: provider.currentWorkPeriodTime,
            totalTime: provider.elapsedTime,
            isActive: provider.isWorkMode,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TimeDisplay(
            label: '休息时间',
            time: provider.totalRestTime,
            isActive: !provider.isWorkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context, TimerProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: provider.toggleTimer,
          child: Text(
            !provider.isRunning
                ? '开始'
                : (provider.isWorkMode ? '休息' : '继续工作'),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: provider.resetTimer,
          child: const Text('重置'),
        ),
      ],
    );
  }
}

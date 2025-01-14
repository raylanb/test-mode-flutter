import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerProvider with ChangeNotifier {
  int targetDuration = 60; // 默认60分钟
  int elapsedTime = 0; // 已经过时间（秒）
  int restTime = 0; // 休息时间（秒）
  int workTimeAtLastRest = 0; // 上次休息时的工作时间
  bool isRunning = false;
  bool isWorkMode = true;
  DateTime? startTime; // 总开始时间
  DateTime? currentPeriodStartTime; // 当前工作时段的开始时间
  int accumulatedRestTime = 0; // 累积的休息时间
  Timer? timer;

  double get progressPercentage {
    if (targetDuration == 0) return 0;
    return (elapsedTime / (targetDuration * 60) * 100).clamp(0, 100);
  }

  int get remainingTime {
    if (isWorkMode) {
      return (targetDuration * 60 - elapsedTime).clamp(0, double.infinity).toInt();
    } else {
      return restTime.clamp(0, double.infinity).toInt();
    }
  }

  String get startTimeFormatted {
    if (currentPeriodStartTime == null || !isWorkMode) return '未开始';
    return '${currentPeriodStartTime!.hour.toString().padLeft(2, '0')}:${currentPeriodStartTime!.minute.toString().padLeft(2, '0')}';
  }

  String get estimatedEndTimeFormatted {
    if (currentPeriodStartTime == null || !isRunning || !isWorkMode) return '未开始';
    final remainingWorkTime = targetDuration * 60 - elapsedTime;
    final endTime = DateTime.now().add(Duration(seconds: remainingWorkTime));
    return '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  int get currentWorkPeriodTime => elapsedTime - workTimeAtLastRest;

  int get earnedRestTime => (currentWorkPeriodTime / 3).floor();

  int get totalRestTime {
    if (!isWorkMode) {
      return restTime;
    }
    return earnedRestTime + accumulatedRestTime;
  }

  void startTimer() {
    if (!isRunning) {
      isRunning = true;
      startTime ??= DateTime.now();
      currentPeriodStartTime = DateTime.now();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (isWorkMode) {
          elapsedTime++;
        } else {
          if (restTime > 0) {
            restTime--;
          } else {
            toggleTimer();
          }
        }
        notifyListeners();
      });
    }
  }

  void stopTimer() {
    timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    elapsedTime = 0;
    restTime = 0;
    workTimeAtLastRest = 0;
    isWorkMode = true;
    startTime = null;
    currentPeriodStartTime = null;
    accumulatedRestTime = 0;
    notifyListeners();
  }

  void toggleTimer() {
    if (!isRunning) {
      startTimer();
    } else {
      if (isWorkMode) {
        isWorkMode = false;
        final newRestTime = earnedRestTime + accumulatedRestTime;
        if (newRestTime > 0) {
          restTime = newRestTime;
          workTimeAtLastRest = elapsedTime;
          accumulatedRestTime = 0;
        } else {
          isWorkMode = true;
        }
      } else {
        isWorkMode = true;
        if (restTime > 0) {
          accumulatedRestTime = restTime;
        }
        currentPeriodStartTime = DateTime.now();
      }
      notifyListeners();
    }
  }

  void setTargetDuration(int minutes) {
    targetDuration = minutes;
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

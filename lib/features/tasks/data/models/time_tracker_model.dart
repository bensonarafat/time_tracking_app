import '../../domain/entities/timer_tracker.dart';

class TimerTrackerModel extends TimerTracker {
  const TimerTrackerModel({
    required super.taskId,
    super.timeSpent,
    super.timerStartedAt,
    super.isTimerRunning,
  });
}

import 'package:equatable/equatable.dart';

class TimerTracker extends Equatable {
  final String taskId;
  final DateTime? timerStartedAt;
  final Duration timeSpent;
  final bool isTimerRunning;

  const TimerTracker({
    required this.taskId,
    this.timerStartedAt,
    this.timeSpent = Duration.zero,
    this.isTimerRunning = false,
  });

  TimerTracker copyWith({
    String? taskId,
    DateTime? timerStartedAt,
    Duration? timeSpent,
    bool? isTimerRunning,
  }) {
    return TimerTracker(
      taskId: taskId ?? this.taskId,
      timerStartedAt: timerStartedAt,
      timeSpent: timeSpent ?? this.timeSpent,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
    );
  }

  @override
  List<Object?> get props => [
    taskId,
    timerStartedAt,
    timeSpent,
    isTimerRunning,
  ];
}

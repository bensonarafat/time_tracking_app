part of 'timer_bloc.dart';

sealed class TimerState extends Equatable {
  const TimerState();
  @override
  List<Object?> get props => [];
}

final class TimerInitial extends TimerState {
  const TimerInitial();
}

final class TimerLoaded extends TimerState {
  final TimerTracker? timerTracker;
  const TimerLoaded(this.timerTracker);

  @override
  List<Object?> get props => [timerTracker];
}

final class TimerStarted extends TimerState {
  final String taskId;
  final DateTime startedAt;

  const TimerStarted(this.taskId, this.startedAt);

  @override
  List<Object?> get props => [taskId, startedAt];
}

final class TimerStopped extends TimerState {
  final String taskId;
  final Duration totalTime;

  const TimerStopped(this.taskId, this.totalTime);

  @override
  List<Object?> get props => [taskId, totalTime];
}

final class TimerReset extends TimerState {
  final String taskId;

  const TimerReset(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

final class TimerError extends TimerState {
  final String message;

  const TimerError(this.message);

  @override
  List<Object?> get props => [message];
}

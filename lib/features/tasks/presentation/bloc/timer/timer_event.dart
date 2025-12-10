part of 'timer_bloc.dart';

sealed class TimerEvent extends Equatable {
  const TimerEvent();
}

class GetTimerEvent extends TimerEvent {
  final String taskId;
  const GetTimerEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class StartTimerEvent extends TimerEvent {
  final String taskId;
  final Duration currentTimeSpent;

  const StartTimerEvent(this.taskId, {this.currentTimeSpent = Duration.zero});

  @override
  List<Object?> get props => [taskId, currentTimeSpent];
}

class StopTimerEvent extends TimerEvent {
  final String taskId;
  final Duration totalTimeSpent;

  const StopTimerEvent(this.taskId, this.totalTimeSpent);

  @override
  List<Object?> get props => [taskId, totalTimeSpent];
}

class ResetTimerEvent extends TimerEvent {
  final String taskId;

  const ResetTimerEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

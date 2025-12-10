import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/timer_tracker.dart';
import '../../../domain/usecases/fetch_timer.dart';
import '../../../domain/usecases/task_timer.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final TaskTimer taskTimer;
  final FetchTimer fetchTimer;
  final Map<String, TimerTracker> _timerCache = {};

  TimerBloc({required this.taskTimer, required this.fetchTimer})
    : super(const TimerInitial()) {
    on<GetTimerEvent>(_onGetTimer);
    on<StartTimerEvent>(_onStartTimer);
    on<StopTimerEvent>(_onStopTimer);
    on<ResetTimerEvent>(_onResetTimer);
  }

  Future<void> _onGetTimer(
    GetTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    if (_timerCache.containsKey(event.taskId)) {
      emit(TimerLoaded(_timerCache[event.taskId]));
      return;
    }
    final result = await fetchTimer(event.taskId);
    result.fold(
      (failure) {
        emit(TimerError(failure.message));
      },
      (timerTracker) {
        _timerCache[event.taskId] = timerTracker;
        emit(TimerLoaded(timerTracker));
      },
    );
  }

  Future<void> _onStartTimer(
    StartTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    final result = await taskTimer(
      taskId: event.taskId,
      timeSpent: event.currentTimeSpent,
    );

    result.fold(
      (failure) {
        emit(TimerError(failure.message));
      },
      (_) {
        final startedAt = DateTime.now();
        final timerTracker = TimerTracker(
          taskId: event.taskId,
          timerStartedAt: startedAt,
          timeSpent: event.currentTimeSpent,
          isTimerRunning: true,
        );
        _timerCache[event.taskId] = timerTracker;
        emit(TimerStarted(event.taskId, startedAt));
        emit(TimerLoaded(timerTracker));
      },
    );
  }

  Future<void> _onStopTimer(
    StopTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    final result = await taskTimer(
      taskId: event.taskId,
      timeSpent: event.totalTimeSpent,
    );

    result.fold(
      (failure) {
        emit(TimerError(failure.message));
      },
      (_) {
        final timerTracker = TimerTracker(
          taskId: event.taskId,
          timerStartedAt: null,
          timeSpent: event.totalTimeSpent,
          isTimerRunning: false,
        );
        _timerCache[event.taskId] = timerTracker;

        emit(TimerStopped(event.taskId, event.totalTimeSpent));
        emit(TimerLoaded(timerTracker));
      },
    );
  }

  Future<void> _onResetTimer(
    ResetTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    final result = await taskTimer(
      taskId: event.taskId,
      startedAt: null,
      timeSpent: Duration.zero,
    );

    result.fold(
      (failure) {
        emit(TimerError(failure.message));
      },
      (_) {
        final timerTracker = TimerTracker(
          taskId: event.taskId,
          timerStartedAt: null,
          timeSpent: Duration.zero,
          isTimerRunning: false,
        );
        _timerCache[event.taskId] = timerTracker;

        emit(TimerReset(event.taskId));
        emit(TimerLoaded(timerTracker));
      },
    );
  }
}

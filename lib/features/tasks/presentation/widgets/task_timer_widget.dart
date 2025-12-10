import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/common_extensions.dart';
import '../../domain/entities/timer_tracker.dart';
import '../bloc/timer/timer_bloc.dart';

class TaskTimerWidget extends StatefulWidget {
  final String taskId;
  final bool isHistory;
  const TaskTimerWidget({
    super.key,
    required this.taskId,
    this.isHistory = false,
  });

  @override
  State<TaskTimerWidget> createState() => _TaskTimerWidgetState();
}

class _TaskTimerWidgetState extends State<TaskTimerWidget> {
  Timer? _updateTimer;
  TimerTracker? _currentTimer;

  @override
  void initState() {
    super.initState();

    context.read<TimerBloc>().add(GetTimerEvent(widget.taskId));
    _startPeriodicUpdate();
  }

  void _startPeriodicUpdate() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _currentTimer?.isTimerRunning == true) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void _toggleTimer(TimerTracker timer) {
    if (timer.isTimerRunning) {
      context.read<TimerBloc>().add(
        StopTimerEvent(widget.taskId, timer.currentTimeSpent),
      );
    } else {
      context.read<TimerBloc>().add(
        StartTimerEvent(widget.taskId, currentTimeSpent: timer.timeSpent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimerBloc, TimerState>(
      listenWhen: (previous, current) {
        if (current is TimerLoaded) {
          return current.timerTracker?.taskId == widget.taskId;
        }
        if (current is TimerStarted) {
          return current.taskId == widget.taskId;
        }
        if (current is TimerStopped) {
          return current.taskId == widget.taskId;
        }
        if (current is TimerReset) {
          return current.taskId == widget.taskId;
        }
        return false;
      },
      listener: (context, state) {
        if (state is TimerLoaded &&
            state.timerTracker?.taskId == widget.taskId) {
          setState(() {
            _currentTimer = state.timerTracker;
          });
        }
      },
      child: widget.isHistory
          ? Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Time Spent",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _currentTimer?.currentTimeSpent.format() ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            )
          : _buildTimerDisplay(),
    );
  }

  Widget _buildTimerDisplay() {
    final timer = _currentTimer;

    if (timer == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: timer.isTimerRunning
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.timer,
            size: 14,
            color: timer.isTimerRunning ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            timer.currentTimeSpent.format(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: timer.isTimerRunning ? Colors.green : Colors.grey[700],
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _toggleTimer(timer),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: timer.isTimerRunning
                    ? Colors.red.withValues(alpha: 0.1)
                    : Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                timer.isTimerRunning ? Icons.stop : Icons.play_arrow,
                size: 16,
                color: timer.isTimerRunning ? Colors.red : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

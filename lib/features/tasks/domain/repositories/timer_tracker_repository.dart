import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/timer_tracker.dart';

abstract class TimerTrackerRepository {
  Future<Either<Failure, void>> saveTimerState({
    required String taskId,
    DateTime? startedAt,
    Duration? timeSpent,
  });
  Future<Either<Failure, TimerTracker>> getTimerState(String taskId);

  Future<Either<Failure, void>> clearTimerState(String taskId);
}

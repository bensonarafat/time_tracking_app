import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/timer_tracker_repository.dart';

class TaskTimer {
  final TimerTrackerRepository repository;

  TaskTimer(this.repository);

  Future<Either<Failure, void>> call({
    required String taskId,
    DateTime? startedAt,
    Duration? timeSpent,
  }) async {
    return await repository.saveTimerState(
      taskId: taskId,
      startedAt: startedAt,
      timeSpent: timeSpent,
    );
  }
}

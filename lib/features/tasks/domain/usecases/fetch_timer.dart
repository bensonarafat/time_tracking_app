import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/timer_tracker.dart';
import '../repositories/timer_tracker_repository.dart';

class FetchTimer {
  final TimerTrackerRepository repository;

  FetchTimer(this.repository);

  Future<Either<Failure, TimerTracker>> call(String taskId) async {
    return await repository.getTimerState(taskId);
  }
}

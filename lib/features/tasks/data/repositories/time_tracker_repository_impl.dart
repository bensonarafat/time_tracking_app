import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/timer_tracker_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../models/time_tracker_model.dart';

class TimeTrackerRepositoryImpl implements TimerTrackerRepository {
  final TaskLocalDataSource localDataSource;

  TimeTrackerRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveTimerState({
    required String taskId,
    DateTime? startedAt,
    Duration? timeSpent,
  }) async {
    try {
      await localDataSource.saveTimerState(taskId, startedAt, timeSpent);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, TimerTrackerModel>> getTimerState(
    String taskId,
  ) async {
    try {
      final state = await localDataSource.getTimerState(taskId);
      final timeTracker = TimerTrackerModel(
        taskId: taskId,
        timerStartedAt: state['startedAt'] as DateTime?,
        timeSpent: state['timeSpent'] as Duration? ?? Duration.zero,
        isTimerRunning: state['startedAt'] != null,
      );
      return Right(timeTracker);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearTimerState(String taskId) async {
    try {
      await localDataSource.saveTimerState(taskId, null, Duration.zero);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }
}

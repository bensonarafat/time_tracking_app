import 'package:fpdart/fpdart.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_status.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, TaskModel>> createTask(String content) async {
    try {
      final task = await remoteDataSource.createTask(content);
      await localDataSource.saveTaskStatus(task.id, task.status);
      return Right(task);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TaskModel>>> fetchTasks() async {
    try {
      List<TaskModel> allTasks = await remoteDataSource.getTasks();
      final tasks = <TaskModel>[];
      for (var remoteTask in allTasks) {
        final status = await localDataSource.getTaskStatus(remoteTask.id);
        tasks.add(remoteTask.copyWith(status: status ?? remoteTask.status));
      }

      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, TaskModel>> updateTask({
    required String taskId,
    required String content,
  }) async {
    try {
      final task = await remoteDataSource.updateTask(taskId, content: content);
      return Right(task);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, TaskModel>> fetchTask(String taskId) async {
    try {
      final task = await remoteDataSource.getTask(taskId);
      final status = await localDataSource.getTaskStatus(task.id);

      final updatedTask = task.copyWith(status: status ?? task.status);
      return Right(updatedTask);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> changeTaskStatus(
    String taskId,
    TaskStatus status,
  ) async {
    try {
      await localDataSource.saveTaskStatus(taskId, status);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> closeOpenTask(
    Task task, {
    bool isClose = false,
  }) async {
    try {
      TaskModel tk = task as TaskModel;
      await remoteDataSource.closeOpenTask(task.id, isClose: isClose);
      if (isClose) {
        final completedTask = tk.copyWith(
          dateCompleted: DateTime.now(),
          isCompleted: true,
        );
        await localDataSource.saveHistoryTask(completedTask);
      } else {
        await localDataSource.removeHistoryTask(tk.id);
      }
      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> fetchHistoryTasks() async {
    try {
      List<TaskModel> allTasks = await localDataSource.getHistoryTasks();
      final tasks = <TaskModel>[];
      for (var remoteTask in allTasks) {
        final status = await localDataSource.getTaskStatus(remoteTask.id);
        tasks.add(remoteTask.copyWith(status: status ?? remoteTask.status));
      }
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}

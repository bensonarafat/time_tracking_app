import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import 'package:fpdart/fpdart.dart' hide Task;

import '../entities/task_status.dart';

abstract class TaskRepository {
  Future<Either<Failure, Task>> createTask(String content);
  Future<Either<Failure, Task>> updateTask({
    required String taskId,
    required String content,
  });
  Future<Either<Failure, void>> changeTaskStatus(
    String taskId,
    TaskStatus status,
  );
  Future<Either<Failure, List<Task>>> fetchTasks();
  Future<Either<Failure, Task>> fetchTask(String taskId);
}

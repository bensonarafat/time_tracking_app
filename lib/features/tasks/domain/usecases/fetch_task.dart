import 'package:fpdart/fpdart.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class FetchTask {
  final TaskRepository repository;

  FetchTask(this.repository);

  Future<Either<Failure, Task>> call(String taskId) async {
    return await repository.fetchTask(taskId);
  }
}

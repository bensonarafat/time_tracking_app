import 'package:fpdart/fpdart.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class EditTask {
  final TaskRepository repository;

  EditTask(this.repository);

  Future<Either<Failure, Task>> call({
    required String taskId,
    required String content,
  }) async {
    return await repository.updateTask(taskId: taskId, content: content);
  }
}

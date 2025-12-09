import 'package:fpdart/fpdart.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<Either<Failure, Task>> call(String content) async {
    return await repository.createTask(content);
  }
}

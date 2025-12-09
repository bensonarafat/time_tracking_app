import 'package:fpdart/fpdart.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class FetchTasks {
  final TaskRepository repository;

  FetchTasks(this.repository);

  Future<Either<Failure, List<Task>>> call({bool history = false}) async {
    return await repository.fetchTasks();
  }
}

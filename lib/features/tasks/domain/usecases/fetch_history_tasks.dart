import 'package:fpdart/fpdart.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class FetchHistoryTasks {
  final TaskRepository repository;

  FetchHistoryTasks(this.repository);

  Future<Either<Failure, List<Task>>> call() async {
    return await repository.fetchHistoryTasks();
  }
}

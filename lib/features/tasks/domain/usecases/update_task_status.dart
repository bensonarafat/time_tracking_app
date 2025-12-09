import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/task_status.dart';
import '../repositories/task_repository.dart';

class UpdateTaskStatus {
  final TaskRepository repository;

  UpdateTaskStatus(this.repository);

  Future<Either<Failure, void>> call({
    required String taskId,
    required TaskStatus status,
  }) async {
    return await repository.changeTaskStatus(taskId, status);
  }
}

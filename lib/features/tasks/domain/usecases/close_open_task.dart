import 'package:fpdart/fpdart.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CloseOpenTask {
  final TaskRepository repository;

  CloseOpenTask(this.repository);

  Future<Either<Failure, void>> call(Task task, {bool isClose = true}) async {
    return await repository.closeOpenTask(task, isClose: isClose);
  }
}

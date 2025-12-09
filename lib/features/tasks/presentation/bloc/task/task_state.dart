part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

final class TaskInitial extends TaskState {
  const TaskInitial();
}

final class TaskLoading extends TaskState {
  const TaskLoading();
}

final class TasksLoaded extends TaskState {
  final List<Task> tasks;

  const TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];

  List<Task> getTasksByStatus(TaskStatus status) {
    return tasks.where((task) => task.status == status).toList();
  }

  List<Task> get completedTasks {
    return tasks.where((task) => task.status == TaskStatus.done).toList();
  }

  List<Task> get activeTasks {
    return tasks.where((task) => task.status != TaskStatus.done).toList();
  }

  Task? getTaskById(String id) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
}

final class TaskLoaded extends TaskState {
  final Task task;

  const TaskLoaded(this.task);

  @override
  List<Object?> get props => [task];
}

final class TaskCreated extends TaskState {
  final Task task;

  const TaskCreated(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskUpdated extends TaskState {
  final Task task;

  const TaskUpdated(this.task);

  @override
  List<Object?> get props => [task];
}

final class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

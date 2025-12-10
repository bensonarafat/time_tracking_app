part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

final class TaskInitial extends TaskState {
  const TaskInitial();
}

final class TasksLoading extends TaskState {
  const TasksLoading();
}

final class TasksLoaded extends TaskState {
  final List<Task> tasks;

  const TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];

  Task? getTaskById(String id) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
}

final class TaskLoading extends TaskState {
  const TaskLoading();
}

final class TasksLoadedHistory extends TaskState {
  final List<Task> tasks;

  const TasksLoadedHistory(this.tasks);

  @override
  List<Object?> get props => [tasks];
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

class StatusChanged extends TaskState {
  final Task task;
  final TaskStatus status;

  const StatusChanged({required this.task, required this.status});

  @override
  List<Object?> get props => [task, status];
}

final class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

final class CloseOpen extends TaskState {}

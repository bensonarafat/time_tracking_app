part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();
}

class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskEvent extends TaskEvent {
  final String taskId;

  const LoadTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class CreateTaskEvent extends TaskEvent {
  final String content;
  const CreateTaskEvent(this.content);

  @override
  List<Object?> get props => [content];
}

class UpdateTaskEvent extends TaskEvent {
  final String taskId;
  final String content;
  const UpdateTaskEvent({required this.taskId, required this.content});

  @override
  List<Object?> get props => [taskId, content];
}

class ChangeTaskStatus extends TaskEvent {
  final String taskId;
  final TaskStatus status;

  const ChangeTaskStatus({required this.taskId, required this.status});

  @override
  List<Object?> get props => [taskId, status];
}

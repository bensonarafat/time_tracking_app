part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();
}

class LoadTasksEvent extends TaskEvent {
  final bool history;
  const LoadTasksEvent({this.history = false});

  @override
  List<Object?> get props => [history];
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

class CloseOpenTaskEvent extends TaskEvent {
  final Task task;
  final bool? isClose;
  const CloseOpenTaskEvent({this.isClose = false, required this.task});
  @override
  List<Object?> get props => [isClose, task];
}

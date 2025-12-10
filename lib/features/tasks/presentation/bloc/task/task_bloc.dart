import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/task.dart';
import '../../../domain/entities/task_status.dart';
import '../../../domain/usecases/close_open_task.dart';
import '../../../domain/usecases/create_task.dart';
import '../../../domain/usecases/edit_task.dart';
import '../../../domain/usecases/fetch_history_tasks.dart';
import '../../../domain/usecases/fetch_task.dart';
import '../../../domain/usecases/fetch_tasks.dart';
import '../../../domain/usecases/task_timer.dart';
import '../../../domain/usecases/update_task_status.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final FetchTasks getTasks;
  final FetchTask getTask;
  final CreateTask createTask;
  final EditTask updateTask;
  final TaskTimer taskTimer;
  final CloseOpenTask closeOpenTask;
  final UpdateTaskStatus updateTaskStatus;
  final FetchHistoryTasks getHistoryTasks;
  List<Task> cachedTasks = [];
  TaskBloc({
    required this.createTask,
    required this.getTasks,
    required this.getTask,
    required this.updateTask,
    required this.taskTimer,
    required this.updateTaskStatus,
    required this.getHistoryTasks,
    required this.closeOpenTask,
  }) : super(const TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadTaskEvent>(_onLoadTask);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<ChangeTaskStatus>(_onChangeTaskStatus);
    on<CloseOpenTaskEvent>(_onCloseOpenTask);
    on<LoadHistoryTasksEvent>(_onLoadHistoryTasks);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TasksLoading());
    final result = await getTasks();
    result.fold((failure) => emit(TaskError(failure.message)), (tasks) {
      cachedTasks = tasks;
      emit(TasksLoaded(tasks));
    });
  }

  Future<void> _onLoadTask(LoadTaskEvent event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    final result = await getTask(event.taskId);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (task) => emit(TaskLoaded(task)),
    );
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await createTask(event.content);
    result.fold((failure) => emit(TaskError(failure.message)), (task) {
      cachedTasks.add(task);
      emit(TaskCreated(task));
      emit(TasksLoaded(cachedTasks));
    });
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await updateTask(
      taskId: event.taskId,
      content: event.content,
    );

    result.fold(
      (failure) {
        final message = failure.message;
        emit(TaskError(message));
        if (cachedTasks.isNotEmpty) {
          emit(TasksLoaded(cachedTasks));
        }
      },
      (task) {
        final index = cachedTasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          cachedTasks[index] = task;
        }
        emit(TaskUpdated(task));
        emit(TasksLoaded(cachedTasks));
      },
    );
  }

  Future<void> _onChangeTaskStatus(
    ChangeTaskStatus event,
    Emitter<TaskState> emit,
  ) async {
    final result = await updateTaskStatus(
      taskId: event.taskId,
      status: event.status,
    );

    result.fold(
      (failure) {
        final message = failure.message;
        emit(TaskError(message));
      },
      (s) {
        final index = cachedTasks.indexWhere((t) => t.id == event.taskId);
        if (index != -1) {
          Task updated = cachedTasks[index].copyWith(status: event.status);
          cachedTasks[index] = updated;
          emit(StatusChanged(task: updated, status: event.status));
        }
        emit(TasksLoaded(cachedTasks));
      },
    );
  }

  Future<void> _onCloseOpenTask(
    CloseOpenTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await closeOpenTask(
      event.task,
      isClose: event.isClose ?? true,
    );
    result.fold(
      (failure) {
        final message = failure.message;
        emit(TaskError(message));
      },
      (s) {
        final index = cachedTasks.indexWhere((t) => t.id == event.task.id);
        if (index != -1) {
          final updated = cachedTasks[index].copyWith(
            isCompleted: event.isClose ?? true,
          );
          cachedTasks[index] = updated;
        }
        emit(TasksLoaded(cachedTasks));
      },
    );
  }

  Future<void> _onLoadHistoryTasks(
    LoadHistoryTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await getHistoryTasks();
    result.fold((failure) => emit(TaskError(failure.message)), (tasks) {
      emit(TasksLoadedHistory(tasks));
    });
  }
}

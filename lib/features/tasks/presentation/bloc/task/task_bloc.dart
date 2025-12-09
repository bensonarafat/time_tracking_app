import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/task.dart';
import '../../../domain/entities/task_status.dart';
import '../../../domain/usecases/create_task.dart';
import '../../../domain/usecases/edit_task.dart';
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
  final UpdateTaskStatus updateTaskStatus;
  List<Task> cachedTasks = [];
  TaskBloc({
    required this.createTask,
    required this.getTasks,
    required this.getTask,
    required this.updateTask,
    required this.taskTimer,
    required this.updateTaskStatus,
  }) : super(const TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadTaskEvent>(_onLoadTask);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<ChangeTaskStatus>(_onChangeTaskStatus);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
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
          final updated = cachedTasks[index].copyWith(status: event.status);
          cachedTasks[index] = updated;
        }
        emit(TasksLoaded(cachedTasks));
      },
    );
  }
}

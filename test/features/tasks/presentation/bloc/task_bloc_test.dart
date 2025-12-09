import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' hide Task;
import 'package:mocktail/mocktail.dart';
import 'package:time_tracking_app/core/errors/failures.dart';
import 'package:time_tracking_app/features/tasks/domain/entities/task.dart';
import 'package:time_tracking_app/features/tasks/domain/entities/task_status.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/create_task.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/edit_task.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/fetch_task.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/fetch_tasks.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/task_timer.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/update_task_status.dart';
import 'package:time_tracking_app/features/tasks/presentation/bloc/task/task_bloc.dart';

class MockFetchTasks extends Mock implements FetchTasks {}

class MockFetchTask extends Mock implements FetchTask {}

class MockCreateTask extends Mock implements CreateTask {}

class MockEditTask extends Mock implements EditTask {}

class MockTaskTimer extends Mock implements TaskTimer {}

class MockUpdateTaskStatus extends Mock implements UpdateTaskStatus {}

// Test data
const testTaskId = 'task-123';
const testContent = 'Test task content';
const testErrorMessage = 'Test error message';

final testTask = Task(
  id: testTaskId,
  content: testContent,
  status: TaskStatus.todo,
  createdAt: DateTime.now(),
);

final testTask2 = Task(
  id: 'task-456',
  content: 'Another test task',
  status: TaskStatus.inProgress,
  createdAt: DateTime.now(),
);

final testTasks = [testTask, testTask2];

void main() {
  late MockFetchTasks mockFetchTasks;
  late MockFetchTask mockFetchTask;
  late MockCreateTask mockCreateTask;
  late MockEditTask mockEditTask;
  late MockTaskTimer mockTaskTimer;
  late MockUpdateTaskStatus mockUpdateTaskStatus;
  late TaskBloc taskBloc;

  setUp(() {
    mockFetchTasks = MockFetchTasks();
    mockFetchTask = MockFetchTask();
    mockCreateTask = MockCreateTask();
    mockEditTask = MockEditTask();
    mockTaskTimer = MockTaskTimer();
    mockUpdateTaskStatus = MockUpdateTaskStatus();

    taskBloc = TaskBloc(
      getTasks: mockFetchTasks,
      getTask: mockFetchTask,
      createTask: mockCreateTask,
      updateTask: mockEditTask,
      taskTimer: mockTaskTimer,
      updateTaskStatus: mockUpdateTaskStatus,
    );
  });

  tearDown(() {
    taskBloc.close();
  });

  group('TaskBloc', () {
    test('initial state should be TaskInitial', () {
      expect(taskBloc.state, equals(const TaskInitial()));
    });

    group('LoadTasksEvent', () {
      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TasksLoaded] when LoadTasksEvent is added successfully',
        build: () {
          when(
            () => mockFetchTasks(),
          ).thenAnswer((_) async => Right(testTasks));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const LoadTasksEvent()),
        expect: () => [const TaskLoading(), TasksLoaded(testTasks)],
        verify: (_) {
          verify(() => mockFetchTasks()).called(1);
          expect(taskBloc.cachedTasks, equals(testTasks));
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskError] when LoadTasksEvent fails',
        build: () {
          when(
            () => mockFetchTasks(),
          ).thenAnswer((_) async => Left(ServerFailure(testErrorMessage)));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const LoadTasksEvent()),
        expect: () => [const TaskLoading(), const TaskError(testErrorMessage)],
        verify: (_) {
          verify(() => mockFetchTasks()).called(1);
        },
      );
    });

    group('LoadTaskEvent', () {
      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskLoaded] when LoadTaskEvent is added successfully',
        build: () {
          when(
            () => mockFetchTask(any()),
          ).thenAnswer((_) async => Right(testTask));
          return taskBloc;
        },
        act: (bloc) => bloc.add(LoadTaskEvent(testTaskId)),
        expect: () => [const TaskLoading(), TaskLoaded(testTask)],
        verify: (_) {
          verify(() => mockFetchTask(testTaskId)).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskError] when LoadTaskEvent fails',
        build: () {
          when(
            () => mockFetchTask(any()),
          ).thenAnswer((_) async => Left(ServerFailure(testErrorMessage)));
          return taskBloc;
        },
        act: (bloc) => bloc.add(LoadTaskEvent(testTaskId)),
        expect: () => [const TaskLoading(), const TaskError(testErrorMessage)],
        verify: (_) {
          verify(() => mockFetchTask(testTaskId)).called(1);
        },
      );
    });

    group('CreateTaskEvent', () {
      blocTest<TaskBloc, TaskState>(
        'emits [TaskCreated, TasksLoaded] when CreateTaskEvent is added successfully',
        setUp: () {
          taskBloc.cachedTasks = testTasks.toList();
        },
        build: () {
          when(
            () => mockCreateTask(any()),
          ).thenAnswer((_) async => Right(testTask));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const CreateTaskEvent(testContent)),
        expect: () => [
          TaskCreated(testTask),
          TasksLoaded([...testTasks, testTask]),
        ],
        verify: (_) {
          verify(() => mockCreateTask(testContent)).called(1);
          expect(taskBloc.cachedTasks.length, equals(testTasks.length + 1));
          expect(taskBloc.cachedTasks.last, equals(testTask));
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskError] when CreateTaskEvent fails',
        build: () {
          when(
            () => mockCreateTask(any()),
          ).thenAnswer((_) async => Left(ServerFailure(testErrorMessage)));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const CreateTaskEvent(testContent)),
        expect: () => [const TaskError(testErrorMessage)],
        verify: (_) {
          verify(() => mockCreateTask(testContent)).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'adds task to empty cache when CreateTaskEvent succeeds',
        build: () {
          when(
            () => mockCreateTask(any()),
          ).thenAnswer((_) async => Right(testTask));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const CreateTaskEvent(testContent)),
        expect: () => [
          TaskCreated(testTask),
          TasksLoaded([testTask]),
        ],
        verify: (_) {
          expect(taskBloc.cachedTasks, equals([testTask]));
        },
      );
    });
  });
}

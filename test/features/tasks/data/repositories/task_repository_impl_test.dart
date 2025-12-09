import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_tracking_app/core/errors/failures.dart';
import 'package:time_tracking_app/features/tasks/domain/entities/task_status.dart';

class MockRemoteDataSource extends Mock implements TaskRemoteDataSource {}

class MockLocalDataSource extends Mock implements TaskLocalDataSource {}

void main() {
  late TaskRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = TaskRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  const taskId = "123";
  const content = "New Task";

  final taskModel = TaskModel(
    id: taskId,
    content: content,
    createdAt: DateTime(2024, 1, 1),
    status: TaskStatus.todo,
    isCompleted: false,
  );

  group("TaskRepositoryImpl - createTask", () {
    test(
      "should create task, save its status locally, and return TaskModel",
      () async {
        // Arrange
        when(
          () => mockRemote.createTask(content),
        ).thenAnswer((_) async => taskModel);
        when(
          () => mockLocal.saveTaskStatus(taskId, TaskStatus.todo),
        ).thenAnswer((_) async => Future.value());
        final result = await repository.createTask(content);
        expect(result, Right(taskModel));
        verify(() => mockRemote.createTask(content)).called(1);
        verify(
          () => mockLocal.saveTaskStatus(taskId, TaskStatus.todo),
        ).called(1);
      },
    );

    test("should return ServerFailure when remote throws an error", () async {
      when(
        () => mockRemote.createTask(content),
      ).thenThrow(Exception("Network error"));

      final result = await repository.createTask(content);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });
  });

  group("TaskRepositoryImpl - fetchTask", () {
    test("should fetch task from remote and merge local status", () async {
      // Arrange
      when(() => mockRemote.getTask(taskId)).thenAnswer((_) async => taskModel);

      when(
        () => mockLocal.getTaskStatus(taskId),
      ).thenAnswer((_) async => TaskStatus.done);
      final result = await repository.fetchTask(taskId);
      expect(result.isRight(), true);

      final fetched = result.getOrElse((_) => taskModel);
      expect(fetched.id, taskId);
      expect(fetched.status, TaskStatus.done);

      verify(() => mockRemote.getTask(taskId)).called(1);
      verify(() => mockLocal.getTaskStatus(taskId)).called(1);
    });

    test("should fallback to remote status when local is null", () async {
      when(() => mockRemote.getTask(taskId)).thenAnswer((_) async => taskModel);

      when(() => mockLocal.getTaskStatus(taskId)).thenAnswer((_) async => null);

      final result = await repository.fetchTask(taskId);

      final fetched = result.getOrElse((_) => taskModel);
      expect(fetched.status, TaskStatus.todo);

      verify(() => mockRemote.getTask(taskId)).called(1);
      verify(() => mockLocal.getTaskStatus(taskId)).called(1);
    });

    test("should return failure when remote throws", () async {
      when(
        () => mockRemote.getTask(taskId),
      ).thenThrow(Exception("something bad"));

      final result = await repository.fetchTask(taskId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });
  });
}

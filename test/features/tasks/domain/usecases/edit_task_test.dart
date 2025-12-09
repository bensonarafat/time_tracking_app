import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' hide Task;
import 'package:mocktail/mocktail.dart';
import 'package:time_tracking_app/features/tasks/domain/entities/task.dart';
import 'package:time_tracking_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/edit_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late EditTask usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = EditTask(mockTaskRepository);
  });

  final content = "Update to content";
  final id = "123";
  final updatedTask = Task(
    id: "123",
    content: content,
    createdAt: DateTime.now(),
  );

  group("UpdateTask", () {
    test("should update task successfully with task content", () async {
      when(
        () => mockTaskRepository.updateTask(taskId: id, content: content),
      ).thenAnswer((_) async => Right(updatedTask));
      final result = await usecase(taskId: id, content: content);
      expect(result, Right(updatedTask));
      verify(
        () => mockTaskRepository.updateTask(taskId: id, content: content),
      ).called(1);
      verifyNoMoreInteractions(mockTaskRepository);
    });
  });
}

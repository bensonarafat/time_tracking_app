import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository;

void main() {
  late EditTask usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = EditTask(mockTaskRepository);
  });

  final task = Task(
    id: "123", 
    content: "This is a task", 
    status: TaskStatus.todo,
    createdAt: DateTime.now(),
  );
  final updated = task.copyWith(
    content: "This is an updated task"
  );

  group("UpdateTask", () {
    test("should update task successfully with task model", () async {
      when(() => mockTaskRepository.updateTask(task: updated),
      ).thenAnswer((_) async => Right(updated));
      final result = await usecase(updated); 
      expect(result, Right(updated));
      verify(() => mockTaskRepository.updateTask(task: updated)).called(1);
      verifyNoMoreInteractions(mockTaskRepository);
    });
  });
}
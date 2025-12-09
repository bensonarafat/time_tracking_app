import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart' hide Task;

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late CreateTask usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = CreateTask(mockTaskRepository);
  });

  const content = "My first task for the day";
  final createdTask = Task(
    id: "123",
    content: content,
    status: TaskStatus.todo,
    createdAt: DateTime(2025, 12, 9),
  );

  group("CreateTask", () {
    test("should create task successfully with content", () async {
      when(
        () => mockTaskRepository.createTask(content),
      ).thenAnswer((_) async => Right(createdTask));

      final result = await usecase(content);

      expect(result, Right(createdTask));
      verify(() => mockTaskRepository.createTask(content)).called(1);
      verifyNoMoreInteractions(mockTaskRepository);
    });
  });
}

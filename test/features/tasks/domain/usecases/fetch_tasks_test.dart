import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late FetchTasks usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = FetchTasks(mockTaskRepository);
  });

  final task1 = Task(
    id: "1",
    content: "Task One",
    createdAt: DateTime(2024, 1, 1),
    status: TaskStatus.todo,
  );

  final task2 = Task(
    id: "2",
    content: "Task Two",
    createdAt: DateTime(2024, 1, 2),
    status: TaskStatus.inProgress,
  );

  final tasks = [task1, task2];

  group("FetchTasks Usecase", () {
    test("should fetch list of tasks successfully", () async {
      when(
        () => mockTaskRepository.fetchTasks(),
      ).thenAnswer((_) async => Right(tasks));
      final result = await usecase();
      expect(result, Right(tasks));
      verify(() => mockTaskRepository.fetchTasks()).called(1);
      verifyNoMoreInteractions(mockTaskRepository);
    });

    test("should return Failure when repository fails", () async {
      const failure = ServerFailure("Unable to fetch tasks");
      when(
        () => mockTaskRepository.fetchTasks(),
      ).thenAnswer((_) async => Left(failure));
      final result = await usecase();
      expect(result, Left(failure));
    });
  });
}

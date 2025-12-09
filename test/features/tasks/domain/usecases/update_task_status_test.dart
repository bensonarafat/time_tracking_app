import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late UpdateTaskStatus usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = UpdateTaskStatus(mockTaskRepository);
  });

  const taskId = "123";
  const newStatus = TaskStatus.done;

  group("UpdateTaskStatus Usecase", () {
    test("should update the task status successfully", () async {
      when(
        () => mockTaskRepository.changeTaskStatus(taskId, newStatus),
      ).thenAnswer((_) async => const Right(null));
      final result = await usecase(taskId: taskId, status: newStatus);
      expect(result, const Right(null));
      verify(
        () => mockTaskRepository.changeTaskStatus(taskId, newStatus),
      ).called(1);
      verifyNoMoreInteractions(mockTaskRepository);
    });
  });
}

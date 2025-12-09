import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  late FetchComments usecase;
  late MockCommentRepository mockCommentRepository;

  setUp(() {
    mockCommentRepository = MockCommentRepository();
    usecase = FetchComments(mockCommentRepository);
  });

  const taskId = "task_001";

  final comments = [
    Comment(
      id: "c1",
      taskId: taskId,
      content: "First comment",
      postedAt: DateTime(2024, 1, 1),
    ),
    Comment(
      id: "c2",
      taskId: taskId,
      content: "Another one",
      postedAt: DateTime(2024, 1, 2),
    ),
  ];

  group("FetchComments Usecase", () {
    test("should return a list of comments for a task", () async {
      when(
        () => mockCommentRepository.fetchComments(taskId),
      ).thenAnswer((_) async => Right(comments));
      final result = await usecase(taskId);

      expect(result, Right(comments));
      verify(() => mockCommentRepository.fetchComments(taskId)).called(1);
      verifyNoMoreInteractions(mockCommentRepository);
    });

    test("should return failure if repository fails", () async {
      const failure = ServerFailure("Could not fetch comments");
      when(
        () => mockCommentRepository.fetchComments(taskId),
      ).thenAnswer((_) async => Left(failure));
      final result = await usecase(taskId);
      expect(result, Left(failure));
    });
  });
}

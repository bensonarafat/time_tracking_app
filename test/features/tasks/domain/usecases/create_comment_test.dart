import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_tracking_app/core/errors/failures.dart';
import 'package:time_tracking_app/features/tasks/domain/entities/comment.dart';
import 'package:time_tracking_app/features/tasks/domain/repositories/comment_repository.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/create_comment.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  late CreateComment usecase;
  late MockCommentRepository mockCommentRepository;

  setUp(() {
    mockCommentRepository = MockCommentRepository();
    usecase = CreateComment(mockCommentRepository);
  });

  const taskId = "task123";
  const content = "Great work!";

  final comment = Comment(
    id: "c1",
    taskId: taskId,
    content: content,
    postedAt: DateTime(2024, 1, 1),
  );

  group("CreateComment Usecase", () {
    test("should successfully create a comment", () async {
      when(
        () => mockCommentRepository.createComment(content, taskId: taskId),
      ).thenAnswer((_) async => Right(comment));

      final result = await usecase(content, taskId: taskId);

      expect(result, Right(comment));
      verify(
        () => mockCommentRepository.createComment(content, taskId: taskId),
      ).called(1);
      verifyNoMoreInteractions(mockCommentRepository);
    });

    test("should return a failure when repository fails", () async {
      const failure = ServerFailure("Failed to create comment");

      when(
        () => mockCommentRepository.createComment(content, taskId: taskId),
      ).thenAnswer((_) async => Left(failure));

      final result = await usecase(content, taskId: taskId);

      expect(result, Left(failure));
    });
  });
}

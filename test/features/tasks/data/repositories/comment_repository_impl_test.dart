import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

void main() {
  late MockTaskRemoteDataSource mockRemote;
  late CommentRepositoryImpl repository;

  setUp(() {
    mockRemote = MockTaskRemoteDataSource();
    repository = CommentRepositoryImpl(remoteDataSource: mockRemote);
  });

  const taskId = "task123";
  const content = "New comment";

  final commentModel = CommentModel(
    id: "c1",
    taskId: taskId,
    content: content,
    postedAt: DateTime(2025, 1, 1),
  );

  group('createComment', () {
    test(
      'should return Right(CommentModel) when remote call succeeds',
      () async {
        // arrange
        when(
          () => mockRemote.createComment(taskId, content),
        ).thenAnswer((_) async => commentModel);

        // act
        final result = await repository.createComment(content, taskId: taskId);

        // assert
        expect(result.isRight(), true);
        expect(result.getRight().toNullable(), equals(commentModel));
        verify(() => mockRemote.createComment(taskId, content)).called(1);
      },
    );
  });

  group('fetchComments', () {
    final commentsList = [commentModel];

    test(
      'should return Right(List<CommentModel>) when remote succeeds',
      () async {
        when(
          () => mockRemote.getComments(taskId),
        ).thenAnswer((_) async => commentsList);

        final result = await repository.fetchComments(taskId);

        expect(result.isRight(), true);
        expect(result.getRight().toNullable(), equals(commentsList));
        verify(() => mockRemote.getComments(taskId)).called(1);
      },
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:time_tracking_app/core/errors/failures.dart';
import 'package:time_tracking_app/features/tasks/domain/entities/comment.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/create_comment.dart';
import 'package:time_tracking_app/features/tasks/domain/usecases/fetch_comments.dart';

class MockFetchComments extends Mock implements FetchComments {}

class MockCreateComment extends Mock implements CreateComment {}

const testTaskId = 'task-123';
const testContent = 'Test comment content';
const testErrorMessage = 'Test error message';

final testComment = Comment(
  id: 'comment-123',
  taskId: testTaskId,
  content: testContent,
  postedAt: DateTime.now(),
);

final testComments = [
  testComment,
  Comment(
    id: 'comment-456',
    taskId: testTaskId,
    content: 'Another test comment',
    postedAt: DateTime.now(),
  ),
];

void main() {
  late MockFetchComments mockFetchComments;
  late MockCreateComment mockCreateComment;
  late CommentBloc commentBloc;

  setUp(() {
    mockFetchComments = MockFetchComments();
    mockCreateComment = MockCreateComment();
    commentBloc = CommentBloc(
      createComment: mockCreateComment,
      getComments: mockFetchComments,
    );
  });

  tearDown(() {
    commentBloc.close();
  });

  group('CommentBloc', () {
    test('initial state should be CommentInitial', () {
      expect(commentBloc.state, equals(const CommentInitial()));
    });

    group('LoadCommentsEvent', () {
      blocTest<CommentBloc, CommentState>(
        'emits [CommentsLoading, CommentsLoaded] when LoadCommentsEvent is added successfully',
        build: () {
          when(
            () => mockFetchComments(any()),
          ).thenAnswer((_) async => Right(testComments));
          return commentBloc;
        },
        act: (bloc) => bloc.add(const LoadCommentsEvent(testTaskId)),
        expect: () => [
          const CommentsLoading(testTaskId),
          CommentsLoaded(testTaskId, testComments),
        ],
        verify: (_) {
          verify(() => mockFetchComments(testTaskId)).called(1);
        },
      );

      blocTest<CommentBloc, CommentState>(
        'emits [CommentsLoading, CommentError] when LoadCommentsEvent fails',
        build: () {
          when(
            () => mockFetchComments(any()),
          ).thenAnswer((_) async => Left(ServerFailure(testErrorMessage)));
          return commentBloc;
        },
        act: (bloc) => bloc.add(const LoadCommentsEvent(testTaskId)),
        expect: () => [
          const CommentsLoading(testTaskId),
          const CommentError(testErrorMessage),
        ],
        verify: (_) {
          verify(() => mockFetchComments(testTaskId)).called(1);
        },
      );
    });

    group('AddCommentEvent', () {
      blocTest<CommentBloc, CommentState>(
        'emits [CommentAdded] when AddCommentEvent is added successfully',
        build: () {
          when(
            () => mockCreateComment(any(), taskId: any(named: 'taskId')),
          ).thenAnswer((_) async => Right(testComment));
          return commentBloc;
        },
        act: (bloc) => bloc.add(const AddCommentEvent(testTaskId, testContent)),
        expect: () => [CommentAdded(testComment)],
        verify: (_) {
          verify(
            () => mockCreateComment(testContent, taskId: testTaskId),
          ).called(1);
        },
      );

      blocTest<CommentBloc, CommentState>(
        'emits [CommentError] when AddCommentEvent fails',
        build: () {
          when(
            () => mockCreateComment(any(), taskId: any(named: 'taskId')),
          ).thenAnswer((_) async => Left(ServerFailure(testErrorMessage)));
          return commentBloc;
        },
        act: (bloc) => bloc.add(const AddCommentEvent(testTaskId, testContent)),
        expect: () => [const CommentError(testErrorMessage)],
        verify: (_) {
          verify(
            () => mockCreateComment(testContent, taskId: testTaskId),
          ).called(1);
        },
      );
    });
  });
}

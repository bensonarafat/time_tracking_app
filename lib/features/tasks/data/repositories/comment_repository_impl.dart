import 'package:fpdart/fpdart.dart';
import 'package:time_tracking_app/features/tasks/data/models/comment_model.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/task_remote_data_source.dart';

class CommentRepositoryImpl extends CommentRepository {
  final TaskRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CommentModel>> createComment(
    String content, {
    required String taskId,
  }) async {
    try {
      final comment = await remoteDataSource.createComment(taskId, content);
      return Right(comment);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CommentModel>>> fetchComments(
    String taskId,
  ) async {
    try {
      final comments = await remoteDataSource.getComments(taskId);
      return Right(comments);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}

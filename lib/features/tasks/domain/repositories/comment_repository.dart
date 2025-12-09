import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/comment.dart';

abstract class CommentRepository {
  Future<Either<Failure, Comment>> createComment(
    String content, {
    required String taskId,
  });

  Future<Either<Failure, List<Comment>>> fetchComments(String taskId);
}

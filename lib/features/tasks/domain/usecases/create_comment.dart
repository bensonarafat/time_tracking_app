import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/comment.dart';
import '../repositories/comment_repository.dart';

class CreateComment {
  final CommentRepository repository;

  CreateComment(this.repository);

  Future<Either<Failure, Comment>> call(
    String content, {
    required String taskId,
  }) async {
    return await repository.createComment(content, taskId: taskId);
  }
}

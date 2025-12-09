import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/comment.dart';
import '../repositories/comment_repository.dart';

class FetchComments {
  final CommentRepository repository;

  FetchComments(this.repository);

  Future<Either<Failure, List<Comment>>> call(String taskId) async {
    return await repository.fetchComments(taskId);
  }
}

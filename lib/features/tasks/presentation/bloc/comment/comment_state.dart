part of 'comment_bloc.dart';

sealed class CommentState extends Equatable {
  const CommentState();
  @override
  List<Object?> get props => [];
}

final class CommentInitial extends CommentState {
  const CommentInitial();
}

final class CommentsLoaded extends CommentState {
  final String taskId;
  final List<Comment> comments;

  const CommentsLoaded(this.taskId, this.comments);

  @override
  List<Object?> get props => [taskId, comments];
}

final class CommentAdded extends CommentState {
  final Comment comment;

  const CommentAdded(this.comment);

  @override
  List<Object?> get props => [comment];
}

final class CommentsLoading extends CommentState {
  final String taskId;

  const CommentsLoading(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

final class CommentError extends CommentState {
  final String message;

  const CommentError(this.message);

  @override
  List<Object?> get props => [message];
}

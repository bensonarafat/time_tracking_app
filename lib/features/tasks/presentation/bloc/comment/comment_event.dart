part of 'comment_bloc.dart';

sealed class CommentEvent {
  const CommentEvent();
}

class AddCommentEvent extends CommentEvent {
  final String taskId;
  final String content;

  const AddCommentEvent(this.taskId, this.content);
}

class LoadCommentsEvent extends CommentEvent {
  final String taskId;

  const LoadCommentsEvent(this.taskId);
}

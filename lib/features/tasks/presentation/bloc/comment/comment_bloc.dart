import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/comment.dart';
import '../../../domain/usecases/create_comment.dart';
import '../../../domain/usecases/fetch_comments.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final FetchComments getComments;
  final CreateComment createComment;
  CommentBloc({required this.createComment, required this.getComments})
    : super(const CommentInitial()) {
    on<AddCommentEvent>(_onAddComment);
    on<LoadCommentsEvent>(_onLoadComments);
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    final result = await createComment(event.content, taskId: event.taskId);
    result.fold(
      (failure) => emit(CommentError(failure.message)),
      (comment) => emit(CommentAdded(comment)),
    );
  }

  Future<void> _onLoadComments(
    LoadCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentsLoading(event.taskId));
    final result = await getComments(event.taskId);
    result.fold(
      (failure) => emit(CommentError(failure.message)),
      (comments) => emit(CommentsLoaded(event.taskId, comments)),
    );
  }
}

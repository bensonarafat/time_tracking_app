import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.taskId,
    required super.content,
    required super.postedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      content: json['content'] as String,
      postedAt: DateTime.parse(json['posted_at']),
    );
  }
}

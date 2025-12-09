import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String taskId;
  final String content;
  final DateTime postedAt;

  const Comment({
    required this.id,
    required this.taskId,
    required this.content,
    required this.postedAt,
  });

  @override
  List<Object?> get props => [id, taskId, content, postedAt];
}

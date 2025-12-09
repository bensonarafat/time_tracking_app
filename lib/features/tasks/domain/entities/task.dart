import 'package:equatable/equatable.dart';

import 'task_status.dart';

class Task extends Equatable {
  final String id;
  final String content;
  final TaskStatus status;
  final DateTime createdAt;
  final bool isCompleted;
  final DateTime? dateCompleted;

  const Task({
    required this.id,
    required this.content,
    this.status = TaskStatus.todo,
    required this.createdAt,
    this.isCompleted = false,
    this.dateCompleted,
  });

  Task copyWith({
    String? id,
    String? content,
    TaskStatus? status,
    DateTime? createdAt,
    bool? isCompleted = false,
  }) {
    return Task(
      id: id ?? this.id,
      content: content ?? this.content,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, content, status, createdAt, isCompleted];
}

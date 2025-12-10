import '../../domain/entities/task.dart';
import '../../domain/entities/task_status.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.content,
    super.status = TaskStatus.todo,
    required super.createdAt,
    super.isCompleted,
    super.dateCompleted,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      content: json['content'] as String,
      status: TaskStatus.todo,
      createdAt: DateTime.parse(json['created_at']),
      isCompleted: json['is_completed'],
      dateCompleted: json['date_completed'] != null
          ? DateTime.parse(json['date_completed'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'is_completed': isCompleted,
      'date_completed': dateCompleted?.toIso8601String(),
    };
  }

  @override
  TaskModel copyWith({
    String? id,
    String? content,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? dateCompleted,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      content: content ?? this.content,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      dateCompleted: dateCompleted ?? this.dateCompleted,
    );
  }
}

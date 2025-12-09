enum TaskStatus { todo, inProgress, done }

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return "To Do";
      case TaskStatus.inProgress:
        return "In Progress";
      case TaskStatus.done:
        return "Done";
    }
  }
}

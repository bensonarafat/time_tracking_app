import 'package:hive/hive.dart';

import '../../domain/entities/task_status.dart';

abstract interface class TaskLocalDataSource {
  Future<void> saveTaskStatus(String taskId, TaskStatus status);
  Future<TaskStatus?> getTaskStatus(String taskId);
  Future<void> saveTimerState(
    String taskId,
    DateTime? startedAt,
    Duration? timeSpent,
  );
  Future<Map<String, dynamic>> getTimerState(String taskId);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box<String> taskStatusBox;
  final Box<Map<String, dynamic>> timerStateBox;

  TaskLocalDataSourceImpl({
    required this.taskStatusBox,
    required this.timerStateBox,
  });

  @override
  Future<TaskStatus?> getTaskStatus(String taskId) async {
    final statusString = taskStatusBox.get(taskId);
    if (statusString == null) return null;

    return TaskStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => TaskStatus.todo,
    );
  }

  @override
  Future<Map<String, dynamic>> getTimerState(String taskId) async {
    final data = timerStateBox.get(taskId);

    if (data == null) {
      return {'startedAt': null, 'timeSpent': null};
    }

    return {
      'startedAt': data['startedAt'] != null
          ? DateTime.parse(data['startedAt'] as String)
          : null,
      'timeSpent': data['timeSpent'] != null
          ? Duration(seconds: data['timeSpent'] as int)
          : null,
    };
  }

  @override
  Future<void> saveTimerState(
    String taskId,
    DateTime? startedAt,
    Duration? timeSpent,
  ) async {
    timerStateBox.write(() {
      final data = {
        'startedAt': startedAt?.toIso8601String(),
        'timeSpent': timeSpent?.inSeconds,
      };
      timerStateBox.put(taskId, data);
    });
  }

  @override
  Future<void> saveTaskStatus(String taskId, TaskStatus status) async {
    taskStatusBox.write(() {
      taskStatusBox.put(taskId, status.name);
    });
  }
}

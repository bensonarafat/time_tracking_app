import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_status.dart';
import '../widgets/task_timer_widget.dart';
import 'comment_count_widget.dart';
import 'task_input_field.dart';

class KanbanBoardWidget extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task task, TaskStatus newStatus) onTaskMoved;
  final Function(Task task) onTaskTapped;
  final Function(String content) onAddTask;
  const KanbanBoardWidget({
    super.key,
    required this.tasks,
    required this.onTaskMoved,
    required this.onAddTask,
    required this.onTaskTapped,
  });

  @override
  State<KanbanBoardWidget> createState() => _KanbanBoardWidgetState();
}

class _KanbanBoardWidgetState extends State<KanbanBoardWidget> {
  final ScrollController _horizontalScrollController = ScrollController();
  List<TaskStatus> statues = TaskStatus.values;

  TaskStatus? _addingForStatus;

  final Map<TaskStatus, bool> _dragOverState = {
    for (var status in TaskStatus.values) status: false,
  };

  List<Task> _getTasksByStatus(TaskStatus status) {
    return widget.tasks.where((task) => task.status == status).toList();
  }

  void _onDragAccept(Task task, TaskStatus status) {
    if (task.status != status) {
      widget.onTaskMoved(task, status);
    }
    setState(() {
      _dragOverState[status] = false;
    });
  }

  void _onDragLeave(Task? data, TaskStatus status) {
    setState(() {
      _dragOverState[status] = false;
    });
  }

  void _onDragEnded() {
    setState(() {
      for (var status in TaskStatus.values) {
        _dragOverState[status] = false;
      }
    });
  }

  void _startAddingTask(TaskStatus status) {
    setState(() {
      _addingForStatus = status;
    });
  }

  void _cancelAddingTask() {
    setState(() {
      _addingForStatus = null;
    });
  }

  void _submitNewTask(String content) {
    if (content.isNotEmpty) {
      widget.onAddTask(content);
      _cancelAddingTask();
    }
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true,
          child: ListView.builder(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: statues.length,
            itemBuilder: (context, index) {
              return _buildColumn(statues[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(TaskStatus status) {
    final tasks = _getTasksByStatus(status);
    final title = TaskStatus.values[status.index].displayName;
    final isDragOver = _dragOverState[status]!;
    final isAdding = _addingForStatus == status;

    return Container(
      width: MediaQuery.of(context).size.width / 1.7,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: DragTarget<Task>(
        onWillAcceptWithDetails: (details) => details.data.status != status,
        onAcceptWithDetails: (details) => _onDragAccept(details.data, status),
        onLeave: (data) => _onDragLeave(data, status),
        builder: (context, candidateData, rejectedData) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isDragOver
                  ? Colors.blue.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: isDragOver
                  ? Border.all(
                      color: Colors.blue.withValues(alpha: 0.5),
                      width: 2,
                    )
                  : Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 1,
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${tasks.length}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (status == TaskStatus.todo)
                        GestureDetector(
                          onTap: () {
                            if (isAdding) {
                              _cancelAddingTask();
                            } else {
                              _startAddingTask(status);
                            }
                          },
                          child: Icon(
                            isAdding ? Icons.close : Icons.add,
                            size: 20,
                            color: isAdding ? Colors.red : Colors.blue,
                          ),
                        ),
                    ],
                  ),
                ),

                // Task List
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (isAdding)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TaskInputField(
                              hintText: 'Enter task content...',
                              submitButtonText: 'Add Task',
                              cancelButtonText: 'Cancel',
                              onSubmit: _submitNewTask,
                              onCancel: _cancelAddingTask,
                            ),
                          ),
                        Expanded(
                          child: tasks.isEmpty
                              ? Center(
                                  child: Text(
                                    'No tasks',
                                    style: TextStyle(
                                      color: Colors.grey.withValues(alpha: 0.6),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) {
                                    final task = tasks[index];
                                    return _buildTaskCard(task);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Padding(
      key: ValueKey(task.id),
      padding: const EdgeInsets.only(bottom: 8),
      child: Draggable<Task>(
        data: task,
        feedback: Material(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: _buildTaskContent(task),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.4,
          child: _buildTaskContent(task),
        ),
        onDragEnd: (_) => _onDragEnded(),
        child: GestureDetector(
          onTap: () => widget.onTaskTapped(task),
          child: _buildTaskContent(task),
        ),
      ),
    );
  }

  Widget _buildTaskContent(Task task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.content,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          CommentCountWidget(taskId: task.id),
          SizedBox(height: 8),
          TaskTimerWidget(taskId: task.id),
        ],
      ),
    );
  }
}

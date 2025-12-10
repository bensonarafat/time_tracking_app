import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/common_extensions.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_status.dart';
import '../bloc/comment/comment_bloc.dart';
import '../bloc/task/task_bloc.dart';
import '../widgets/task_input_field.dart';
import '../widgets/task_timer_widget.dart';

class TaskDetailPage extends StatefulWidget {
  final String taskId;
  const TaskDetailPage({super.key, required this.taskId});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTaskEvent(widget.taskId));
    context.read<CommentBloc>().add(LoadCommentsEvent(widget.taskId));
  }

  void _addComment(String value) {
    if (value.isNotEmpty) {
      context.read<CommentBloc>().add(AddCommentEvent(widget.taskId, value));
    }
  }

  void _startEditing(Task task) {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveEdit(String newContent, Task task) {
    if (newContent.isNotEmpty && newContent != task.content) {
      context.read<TaskBloc>().add(
        UpdateTaskEvent(taskId: task.id, content: newContent),
      );
    }
    setState(() {
      _isEditing = false;
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is! TasksLoaded) return const SizedBox.shrink();

              final task = state.getTaskById(widget.taskId);
              if (task == null || _isEditing) return const SizedBox.shrink();

              return PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _startEditing(task);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit Task'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskLoaded) {
            Task task = state.task;

            return BlocListener<CommentBloc, CommentState>(
              listener: (context, commentState) {
                if (commentState is CommentAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Comment added'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.read<CommentBloc>().add(
                    LoadCommentsEvent(widget.taskId),
                  );
                }
                if (commentState is CommentError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(commentState.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTaskCard(task),
                    const SizedBox(height: 8),
                    TaskTimerWidget(taskId: task.id),
                    const SizedBox(height: 8),
                    _buildCommentsSection(),
                  ],
                ),
              ),
            );
          }

          return Center(child: Text("Task not found"));
        },
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEditing) ...[
              TaskInputField(
                initialValue: task.content,
                hintText: 'Edit task content...',
                submitButtonText: 'Save',
                cancelButtonText: 'Cancel',
                onSubmit: (newContent) => _saveEdit(newContent, task),
                onCancel: _cancelEdit,
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.content,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: task.status.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.status.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.calendar_today,
                'Created',
                task.createdAt.format(),
              ),
              if (task.dateCompleted != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.check_circle,
                  'Completed',
                  task.dateCompleted!.format(),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.comment, size: 24),
                SizedBox(width: 8),
                Text(
                  'Comments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TaskInputField(
              onSubmit: (String value) {
                _addComment(value);
              },
              onCancel: () {},
              showCancelButton: false,
              showSubmitButton: false,
              showSendIcon: true,
              autofocus: false,
            ),

            const SizedBox(height: 16),
            BlocBuilder<CommentBloc, CommentState>(
              builder: (context, state) {
                if (state is CommentsLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is CommentsLoaded && state.taskId == widget.taskId) {
                  if (state.comments.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No comments yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: state.comments
                        .map((comment) => _buildCommentItem(comment))
                        .toList(),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.content, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                comment.postedAt.format(),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(value),
      ],
    );
  }
}

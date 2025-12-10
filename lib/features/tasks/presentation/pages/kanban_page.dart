import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/task.dart';
import '../../domain/entities/task_status.dart';
import '../bloc/task/task_bloc.dart';
import '../widgets/kanban_board_widget.dart';

class KanbanPage extends StatelessWidget {
  const KanbanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban Board'),
        elevation: 2,
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/history'),
            icon: const Icon(Icons.history, color: Colors.black87, size: 20),
            label: const Text(
              'History',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<TaskBloc>().add(const LoadTasksEvent());
                  },
                ),
              ),
            );
          } else if (state is TaskCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task created successfully'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading && state is! TasksLoaded) {
            return _buildLoadingWidget();
          }

          if (state is TasksLoaded) {
            if (state.tasks.isEmpty) {
              return _buildEmptyWidget();
            }

            return KanbanBoardWidget(
              tasks: state.tasks,
              onAddTask: (String content) {
                context.read<TaskBloc>().add(CreateTaskEvent(content));
              },
              onTaskTapped: (Task task) {
                context.push('/task/${task.id}');
              },
              onTaskMoved: (Task task, TaskStatus newStatus) {
                context.read<TaskBloc>().add(
                  ChangeTaskStatus(taskId: task.id, status: newStatus),
                );
              },
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  Widget _buildLoadingWidget() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Loading tasks...'),
      ],
    ),
  );

  Widget _buildEmptyWidget() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'No tasks yet',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          'Create your first task to get started',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    ),
  );
}

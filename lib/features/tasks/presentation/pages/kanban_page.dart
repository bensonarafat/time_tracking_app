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
        buildWhen: (previous, next) {
          return next is TasksLoading ||
              next is TasksLoaded ||
              next is TaskError;
        },
        listenWhen: (previous, next) {
          return next is TaskError ||
              next is TaskCreated ||
              next is StatusChanged;
        },
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
          } else if (state is StatusChanged) {
            context.read<TaskBloc>().add(
              CloseOpenTaskEvent(
                task: state.task,
                isClose: state.status == TaskStatus.done,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TasksLoading) {
            return _buildLoadingWidget();
          }
          if (state is TasksLoaded) {
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
}

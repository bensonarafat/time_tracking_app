import 'package:go_router/go_router.dart';

import '../features/tasks/presentation/pages/history_page.dart';
import '../features/tasks/presentation/pages/kanban_page.dart';
import '../features/tasks/presentation/pages/task_detail_page.dart';

class AppRouter {
  static const String kanban = '/';
  static const String task = "/task/:id";
  static const String history = "/history";

  static final GoRouter router = GoRouter(
    initialLocation: kanban,
    routes: [
      GoRoute(path: kanban, builder: (context, state) => const KanbanPage()),
      GoRoute(
        path: task,
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return TaskDetailPage(taskId: taskId);
        },
      ),
      GoRoute(path: history, builder: (context, state) => const HistoryPage()),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di/init_dependencies.dart';
import 'features/tasks/presentation/bloc/comment/comment_bloc.dart';
import 'features/tasks/presentation/bloc/task/task_bloc.dart';
import 'features/tasks/presentation/bloc/timer/timer_bloc.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (_) =>
              serviceLocator<TaskBloc>()..add(const LoadTasksEvent()),
        ),
        BlocProvider<CommentBloc>(create: (_) => serviceLocator<CommentBloc>()),
        BlocProvider<TimerBloc>(create: (_) => serviceLocator<TimerBloc>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: true,
        title: 'Task Tracking app',
        theme: ThemeData(useMaterial3: true),
        routerConfig: AppRouter.router,
      ),
    );
  }
}

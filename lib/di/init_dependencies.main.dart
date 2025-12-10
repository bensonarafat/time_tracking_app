part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  _initHive();

  _initBloc();

  _initUseCases();

  _initRepositories();

  _initDataSources();

  _initExternal();
}

void _initHive() {
  serviceLocator.registerLazySingleton<Box<String>>(
    () => Hive.box<String>(name: "task_status"),
  );

  serviceLocator.registerLazySingleton<Box<Map<String, dynamic>>>(
    () => Hive.box<Map<String, dynamic>>(name: "timer_state"),
  );
}

void _initBloc() {
  serviceLocator.registerFactory(
    () => TaskBloc(
      createTask: serviceLocator(),
      getTasks: serviceLocator(),
      getTask: serviceLocator(),
      updateTask: serviceLocator(),
      taskTimer: serviceLocator(),
      updateTaskStatus: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => CommentBloc(
      createComment: serviceLocator(),
      getComments: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => TimerBloc(taskTimer: serviceLocator(), fetchTimer: serviceLocator()),
  );
}

void _initUseCases() {
  serviceLocator.registerLazySingleton(() => CreateTask(serviceLocator()));
  serviceLocator.registerLazySingleton(() => FetchTasks(serviceLocator()));
  serviceLocator.registerLazySingleton(() => FetchTask(serviceLocator()));
  serviceLocator.registerLazySingleton(() => EditTask(serviceLocator()));
  serviceLocator.registerLazySingleton(() => TaskTimer(serviceLocator()));
  serviceLocator.registerLazySingleton(() => FetchTimer(serviceLocator()));
  serviceLocator.registerLazySingleton(() => CreateComment(serviceLocator()));
  serviceLocator.registerLazySingleton(() => FetchComments(serviceLocator()));
  serviceLocator.registerLazySingleton(
    () => UpdateTaskStatus(serviceLocator()),
  );
}

void _initRepositories() {
  serviceLocator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<TimerTrackerRepository>(
    () => TimeTrackerRepositoryImpl(localDataSource: serviceLocator()),
  );
}

void _initDataSources() {
  serviceLocator.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(
      client: serviceLocator(),
      apiToken: const String.fromEnvironment("TODOIST_API_TOKEN"),
    ),
  );

  serviceLocator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(
      taskStatusBox: serviceLocator(),
      timerStateBox: serviceLocator(),
    ),
  );
}

void _initExternal() {
  serviceLocator.registerLazySingleton(() => http.Client());
}

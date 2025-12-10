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
  serviceLocator.registerLazySingleton<Box<Map<String, dynamic>>>(
    () => Hive.box<Map<String, dynamic>>(name: "history"),
    instanceName: "historyBox",
  );

  serviceLocator.registerLazySingleton<Box<String>>(
    () => Hive.box<String>(name: "task_status"),
    instanceName: "taskStatusBox",
  );

  serviceLocator.registerLazySingleton<Box<Map<String, dynamic>>>(
    () => Hive.box<Map<String, dynamic>>(name: "timer_state"),
    instanceName: "timerStateBox",
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
      closeOpenTask: serviceLocator(),
      getHistoryTasks: serviceLocator(),
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
  serviceLocator.registerLazySingleton(() => CloseOpenTask(serviceLocator()));
  serviceLocator.registerLazySingleton(
    () => FetchHistoryTasks(serviceLocator()),
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
      apiToken: const String.fromEnvironment(
        "TODOIST_API_TOKEN",
        defaultValue: "dd7a8886bb534e7266dd579a24baea9eb7e44c1d",
      ),
    ),
  );

  serviceLocator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(
      taskStatusBox: serviceLocator<Box<String>>(instanceName: "taskStatusBox"),
      timerStateBox: serviceLocator<Box<Map<String, dynamic>>>(
        instanceName: "timerStateBox",
      ),
      historyBox: serviceLocator<Box<Map<String, dynamic>>>(
        instanceName: "historyBox",
      ),
    ),
  );
}

void _initExternal() {
  serviceLocator.registerLazySingleton(() => http.Client());
}

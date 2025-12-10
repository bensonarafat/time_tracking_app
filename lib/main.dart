import 'package:flutter/material.dart';

import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: true,
      title: 'Task Tracking app',
      theme: ThemeData(useMaterial3: true),
      routerConfig: AppRouter.router,
    );
  }
}

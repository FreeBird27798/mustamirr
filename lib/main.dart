import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'core/utils/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mustamirr',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}

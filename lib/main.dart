import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/utils/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/cubit/session_cubit.dart';
import 'features/student/presentation/cubit/notification_badge_cubit.dart';

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
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<SessionCubit>()),
        BlocProvider(create: (_) => sl<NotificationBadgeCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Mustamirr',
        debugShowCheckedModeBanner: false,
        // Phone-first layout: on large screens (tablet / desktop / web) keep the
        // content in a centered, comfortably-wide column instead of stretching
        // edge-to-edge. On phones the column fills the screen as before.
        builder: (context, child) {
          return ColoredBox(
            color: const Color(0xFFDDE5EF),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          );
        },
        routerConfig: appRouter,
      ),
    );
  }
}

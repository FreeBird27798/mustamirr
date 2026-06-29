import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';

// Placeholder pages — will be replaced in later phases
class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Student Home')));
}

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Teacher Home')));
}

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Admin Home')));
}

// Route names
class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const studentHome = '/student';
  static const teacherHome = '/teacher';
  static const adminHome = '/admin';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (context, state) async {
    final loc = state.matchedLocation;

    // Splash manages its own navigation — never redirect away from it
    if (loc == AppRoutes.splash) return null;

    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_done') ?? false;

    // Force onboarding if not done yet
    if (!onboardingDone) {
      return loc == AppRoutes.onboarding ? null : AppRoutes.onboarding;
    }

    final token = prefs.getString('auth_token');
    final role = prefs.getString('user_role');

    final isAuthPage = loc == AppRoutes.login || loc == AppRoutes.register;

    // No token → go to login
    if (token == null) {
      return isAuthPage ? null : AppRoutes.login;
    }

    // Has token but trying to open login/register → redirect by role
    if (isAuthPage) {
      if (role == 'student') return AppRoutes.studentHome;
      if (role == 'teacher') return AppRoutes.teacherHome;
      if (role == 'admin') return AppRoutes.adminHome;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, _) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, _) => const OnboardingPage(),
    ),
    GoRoute(path: AppRoutes.login, builder: (context, _) => const LoginPage()),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, _) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.studentHome,
      builder: (context, _) => const StudentHomePage(),
    ),
    GoRoute(
      path: AppRoutes.teacherHome,
      builder: (context, _) => const TeacherHomePage(),
    ),
    GoRoute(
      path: AppRoutes.adminHome,
      builder: (context, _) => const AdminHomePage(),
    ),
  ],
);

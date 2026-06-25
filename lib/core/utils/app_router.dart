import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Placeholder pages — will be replaced with real screens later
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Login')));
}

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
  static const login = '/login';
  static const studentHome = '/student';
  static const teacherHome = '/teacher';
  static const adminHome = '/admin';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final role = prefs.getString('user_role');

    final isOnLoginPage = state.matchedLocation == AppRoutes.login;

    if (token == null) {
      return isOnLoginPage ? null : AppRoutes.login;
    }

    if (isOnLoginPage) {
      if (role == 'student') return AppRoutes.studentHome;
      if (role == 'teacher') return AppRoutes.teacherHome;
      if (role == 'admin') return AppRoutes.adminHome;
    }

    return null;
  },
  routes: [
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
    GoRoute(path: AppRoutes.studentHome, builder: (_, __) => const StudentHomePage()),
    GoRoute(path: AppRoutes.teacherHome, builder: (_, __) => const TeacherHomePage()),
    GoRoute(path: AppRoutes.adminHome, builder: (_, __) => const AdminHomePage()),
  ],
);

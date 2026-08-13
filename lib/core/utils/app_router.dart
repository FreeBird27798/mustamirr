import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/student/presentation/pages/student_home_page.dart';
import '../../features/student/presentation/pages/favorites_page.dart';
import '../../features/student/presentation/pages/downloads_page.dart';
import '../../features/student/presentation/pages/lessons_page.dart';
import '../../features/student/presentation/pages/notifications_page.dart';
import '../../features/student/presentation/pages/subjects_page.dart';
import '../../features/student/presentation/pages/profile_page.dart';
import '../../features/teacher/presentation/pages/teacher_dashboard_page.dart';
import '../../features/teacher/presentation/pages/teacher_lessons_page.dart';
import '../../features/teacher/presentation/pages/teacher_students_page.dart';
import '../../features/teacher/presentation/pages/teacher_profile_page.dart';
import '../../features/teacher/presentation/pages/manage_lesson_page.dart';
import '../../features/teacher/domain/entities/teacher_lesson_entity.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/admin_users_page.dart';
import '../../features/admin/presentation/pages/admin_profile_page.dart';
import '../../features/admin/presentation/pages/admin_enrollment_page.dart';
import '../../features/admin/presentation/pages/admin_institutions_page.dart';
import '../../features/admin/presentation/pages/admin_subjects_page.dart';
import '../../features/admin/presentation/pages/admin_content_page.dart';

// Route names
class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const studentHome = '/student';
  static const subjects = '/student/subjects';
  static const favorites = '/student/favorites';
  static const downloads = '/student/downloads';
  static const profile = '/student/profile';
  static const teacherHome = '/teacher';
  static const teacherLessons = '/teacher/lessons';
  static const teacherStudents = '/teacher/students';
  static const teacherProfile = '/teacher/profile';
  static const teacherManageLesson = '/teacher/manage-lesson';
  static const adminHome = '/admin';
  static const adminUsers = '/admin/users';
  static const adminSubjects = '/admin/subjects';
  static const adminProfile = '/admin/profile';
  static const adminEnrollment = '/admin/enrollment';
  static const adminInstitutions = '/admin/institutions';
  static const adminContent = '/admin/content';

  static const lessonsRoute = '/student/lessons/:subjectId';
  static String lessonsPath(int subjectId) => '/student/lessons/$subjectId';

  static const notifications = '/student/notifications';
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _StudentShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.studentHome,
              builder: (context, _) => const StudentHomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.subjects,
              builder: (context, _) => const SubjectsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favorites,
              builder: (context, _) => const FavoritesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.downloads,
              builder: (context, _) => const DownloadsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, _) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.lessonsRoute,
      builder: (context, state) {
        final subjectId = int.parse(state.pathParameters['subjectId']!);
        return LessonsPage(subjectId: subjectId);
      },
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, _) => const NotificationsPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _TeacherShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.teacherHome,
              builder: (context, _) => const TeacherDashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.teacherLessons,
              builder: (context, _) => const TeacherLessonsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.teacherStudents,
              builder: (context, _) => const TeacherStudentsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.teacherProfile,
              builder: (context, _) => const TeacherProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.teacherManageLesson,
      builder: (context, state) =>
          ManageLessonPage(lesson: state.extra as TeacherLessonEntity?),
    ),
    GoRoute(
      path: AppRoutes.adminEnrollment,
      builder: (context, _) => const AdminEnrollmentPage(),
    ),
    GoRoute(
      path: AppRoutes.adminInstitutions,
      builder: (context, _) => const AdminInstitutionsPage(),
    ),
    GoRoute(
      path: AppRoutes.adminContent,
      builder: (context, _) => const AdminContentPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _AdminShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.adminHome,
              builder: (context, _) => const AdminDashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.adminSubjects,
              builder: (context, _) => const AdminSubjectsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.adminUsers,
              builder: (context, _) => const AdminUsersPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.adminProfile,
              builder: (context, _) => const AdminProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class _TeacherShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _TeacherShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book_rounded),
              label: 'الدروس',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              activeIcon: Icon(Icons.people_alt_rounded),
              label: 'الطلاب',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'حساب',
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _AdminShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book_rounded),
              label: 'إدارة المواد',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              activeIcon: Icon(Icons.people_alt_rounded),
              label: 'إدارة المستخدمين',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'حساب',
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _StudentShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book_rounded),
              label: 'المواد',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'المفضلة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download_outlined),
              activeIcon: Icon(Icons.download_rounded),
              label: 'التنزيلات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'حساب',
            ),
          ],
        ),
      ),
    );
  }
}

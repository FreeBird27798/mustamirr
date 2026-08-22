import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../domain/entities/teacher_lesson_entity.dart';
import '../../domain/entities/teacher_stats_entity.dart';
import '../../../student/presentation/cubit/notification_badge_cubit.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart';
import '../bloc/dashboard/dashboard_state.dart';
import '../widgets/teacher_header.dart';
import '../widgets/teacher_lesson_card.dart';

class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // refresh the header's unread-notifications dot when the dashboard opens
        context.read<NotificationBadgeCubit>().load();
        return sl<DashboardBloc>()..add(LoadDashboardEvent());
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DashboardError) {
                  return Center(child: Text(state.message));
                } else if (state is DashboardLoaded) {
                  return _DashboardContent(state: state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardLoaded state;
  const _DashboardContent({required this.state});

  Future<void> _openForm(
    BuildContext context, {
    TeacherLessonEntity? lesson,
  }) async {
    final bloc = context.read<DashboardBloc>();
    final result = await context.push<TeacherLessonEntity>(
      AppRoutes.teacherManageLesson,
      extra: lesson,
    );
    if (result != null) {
      if (lesson == null) {
        bloc.add(AddLessonRequested(lesson: result));
      } else {
        bloc.add(UpdateLessonRequested(lesson: result));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        const TeacherHeader(),
        const SizedBox(height: 20),
        const _InstitutionBanner(),
        const SizedBox(height: 20),
        _StatsGrid(stats: state.stats),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _openForm(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          icon: const Icon(Icons.add),
          label: const Text('إضافة درس جديد'),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => context.go(AppRoutes.teacherLessons),
              child: const Text(
                'عرض الكل',
                style: TextStyle(color: AppColors.glow, fontSize: 13),
              ),
            ),
            const Text(
              'أحدث دروسي',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.recentLessons.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('لا توجد دروس بعد')),
          )
        else
          ...state.recentLessons.map(
            (lesson) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TeacherLessonCard(
                lesson: lesson,
                onEdit: () => _openForm(context, lesson: lesson),
                onDelete: () => context.read<DashboardBloc>().add(
                  DeleteLessonRequested(lessonId: lesson.id),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _InstitutionBanner extends StatelessWidget {
  const _InstitutionBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.teacherAffiliation),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.glow.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'أكمل تحديد مؤسستك التعليمية',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'حدّد مؤسستك وصفك لتتمكن من إضافة الدروس',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school_outlined, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final TeacherStatsEntity stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        _StatCard(
          value: '${stats.studentsCount}',
          label: 'الطلاب',
          icon: Icons.people_alt_rounded,
          color: AppColors.glow,
        ),
        _StatCard(
          value: '${stats.lessonsCount}',
          label: 'إجمالي الدروس',
          icon: Icons.menu_book_rounded,
          color: AppColors.primary,
        ),
        _StatCard(
          value: '${stats.coursesCount}',
          label: 'مساقات التدريس',
          icon: Icons.collections_bookmark_rounded,
          color: AppColors.amber,
        ),
        _StatCard(
          value: _formatCount(stats.downloadsCount),
          label: 'التنزيلات',
          icon: Icons.download_rounded,
          color: const Color(0xFF10B981),
        ),
      ],
    );
  }

  String _formatCount(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}K';
    }
    return '$n';
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

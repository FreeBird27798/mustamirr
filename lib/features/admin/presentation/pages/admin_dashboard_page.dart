import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/coming_soon.dart';
import '../../domain/entities/admin_stats_entity.dart';
import '../bloc/admin_dashboard/admin_dashboard_bloc.dart';
import '../bloc/admin_dashboard/admin_dashboard_event.dart';
import '../bloc/admin_dashboard/admin_dashboard_state.dart';
import '../widgets/admin_header.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminDashboardBloc>()..add(LoadAdminDashboardEvent()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
              builder: (context, state) {
                if (state is AdminDashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AdminDashboardError) {
                  return Center(child: Text(state.message));
                } else if (state is AdminDashboardLoaded) {
                  return _DashboardContent(stats: state.stats);
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
  final AdminStatsEntity stats;
  const _DashboardContent({required this.stats});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        const AdminHeader(
          title: 'لوحة الإدارة',
          subtitle: 'نظرة عامة على المنصة',
        ),
        const SizedBox(height: 20),
        _StatsGrid(stats: stats),
        const SizedBox(height: 24),
        const Text(
          'إدارة سريعة',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _QuickTile(
          icon: Icons.assignment_turned_in_outlined,
          title: 'طلبات الانتساب',
          subtitle: 'اعتماد طلبات الطلاب والمعلمين',
          onTap: () => context.push(AppRoutes.adminEnrollment),
        ),
        _QuickTile(
          icon: Icons.apartment_rounded,
          title: 'الجامعات والمدارس',
          subtitle: 'الجامعات، المدارس، التخصصات، الصفوف',
          onTap: () => context.push(AppRoutes.adminInstitutions),
        ),
        _QuickTile(
          icon: Icons.people_alt_outlined,
          title: 'إدارة المستخدمين',
          subtitle: 'الطلاب، المعلمون، الأدوار',
          onTap: () => context.go(AppRoutes.adminUsers),
        ),
        _QuickTile(
          icon: Icons.folder_open_rounded,
          title: 'إدارة المواد',
          subtitle: 'إضافة وتعديل المواد الدراسية',
          onTap: () => context.go(AppRoutes.adminSubjects),
        ),
        _QuickTile(
          icon: Icons.description_outlined,
          title: 'إدارة المحتوى',
          subtitle: 'مراجعة وإدارة الدروس',
          onTap: () => context.push(AppRoutes.adminContent),
        ),
        _QuickTile(
          icon: Icons.bar_chart_rounded,
          title: 'التقارير والإحصائيات',
          subtitle: 'نشاط المنصة والاستخدام',
          onTap: () => showComingSoon(context),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final AdminStatsEntity stats;
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
          value: '${stats.subjectsCount}',
          label: 'إجمالي المواد',
          icon: Icons.menu_book_rounded,
          color: AppColors.primary,
        ),
        _StatCard(
          value: '${stats.teachersCount}',
          label: 'المعلمون',
          icon: Icons.school_rounded,
          color: AppColors.amber,
        ),
        _StatCard(
          value: _formatCount(stats.filesCount),
          label: 'الملفات',
          icon: Icons.insert_drive_file_rounded,
          color: const Color(0xFF10B981),
        ),
      ],
    );
  }

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
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

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(Icons.chevron_left_rounded, color: AppColors.textGrey),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../student/presentation/cubit/notification_badge_cubit.dart';

class TeacherHeader extends StatelessWidget {
  final String title;
  const TeacherHeader({super.key, this.title = 'لوحة المعلم'});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => context.push(AppRoutes.notifications),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_rounded, size: 26),
                  if (context.watch<NotificationBadgeCubit>().state > 0)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => context.push(AppRoutes.teacherSearch),
              child: const Icon(Icons.search_rounded, size: 26),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'مرحبا. ${context.watch<SessionCubit>().state?.name ?? ''}',
              style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
          ],
        ),
      ],
    );
  }
}

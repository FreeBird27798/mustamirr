import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/coming_soon.dart';
import '../../domain/entities/notification_entity.dart';
import '../cubit/notification_badge_cubit.dart';
import '../bloc/notifications/notifications_bloc.dart';
import '../bloc/notifications/notifications_event.dart';
import '../bloc/notifications/notifications_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // opening the screen counts as reading everything → clear the dot
        context.read<NotificationBadgeCubit>().markAllRead();
        return sl<NotificationsBloc>()..add(LoadNotificationsEvent());
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_forward_rounded),
                      ),
                      const Expanded(
                        child: Text(
                          'الإشعارات',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<NotificationsBloc, NotificationsState>(
                      builder: (context, state) {
                        if (state is NotificationsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is NotificationsError) {
                          return Center(child: Text(state.message));
                        } else if (state is NotificationsLoaded) {
                          if (state.notifications.isEmpty) {
                            return const Center(child: Text('لا توجد إشعارات'));
                          }
                          return ListView.separated(
                            itemCount: state.notifications.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, index) => _NotificationCard(
                              notification: state.notifications[index],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  const _NotificationCard({required this.notification});

  IconData get _typeIcon {
    switch (notification.type) {
      case 'update':
        return Icons.menu_book_rounded;
      case 'alert':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showComingSoon(context),
      child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.inputBackground
            : AppColors.glow.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!notification.isRead)
            Container(
              margin: const EdgeInsets.only(top: 4, left: 8),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead
                        ? FontWeight.w500
                        : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                ),
                const SizedBox(height: 6),
                Text(
                  notification.createdAt,
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(_typeIcon, color: AppColors.primary),
        ],
      ),
      ),
    );
  }
}

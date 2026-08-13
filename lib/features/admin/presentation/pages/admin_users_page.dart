import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/confirm_dialog.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../bloc/users/users_bloc.dart';
import '../bloc/users/users_event.dart';
import '../bloc/users/users_state.dart';
import '../widgets/admin_header.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UsersBloc>()..add(LoadUsersEvent()),
      child: const _AdminUsersView(),
    );
  }
}

class _AdminUsersView extends StatefulWidget {
  const _AdminUsersView();

  @override
  State<_AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<_AdminUsersView> {
  bool _showStudents = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AdminHeader(
                      title: 'إدارة المستخدمين',
                      subtitle: state is UsersLoaded
                          ? '${state.users.length} مستخدمًا'
                          : '',
                    ),
                    const SizedBox(height: 20),
                    _Tabs(
                      showStudents: _showStudents,
                      studentsCount: state is UsersLoaded
                          ? state.students.length
                          : 0,
                      teachersCount: state is UsersLoaded
                          ? state.teachers.length
                          : 0,
                      onChanged: (v) => setState(() => _showStudents = v),
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: _buildBody(state)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(UsersState state) {
    if (state is UsersLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is UsersError) {
      return Center(child: Text(state.message));
    } else if (state is UsersLoaded) {
      final list = _showStudents ? state.students : state.teachers;
      if (list.isEmpty) {
        return const Center(child: Text('لا يوجد مستخدمون'));
      }
      return ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _UserCard(user: list[index]),
      );
    }
    return const SizedBox.shrink();
  }
}

class _Tabs extends StatelessWidget {
  final bool showStudents;
  final int studentsCount;
  final int teachersCount;
  final ValueChanged<bool> onChanged;

  const _Tabs({
    required this.showStudents,
    required this.studentsCount,
    required this.teachersCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _tab('الطلاب ($studentsCount)', showStudents, () => onChanged(true)),
          _tab('المعلمون ($teachersCount)', !showStudents, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: active ? AppColors.primary : AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final AdminUserEntity user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Switch(
                value: user.isActive,
                activeThumbColor: AppColors.primary,
                onChanged: (_) => context.read<UsersBloc>().add(
                  ToggleUserActiveEvent(userId: user.id),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary,
                child: Text(
                  user.name.isNotEmpty ? user.name[0] : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  final bloc = context.read<UsersBloc>();
                  final confirmed = await showConfirmDialog(
                    context,
                    title: 'حذف المستخدم',
                    message: 'هل أنت متأكد من حذف "${user.name}"؟',
                    confirmText: 'حذف',
                    confirmColor: Colors.red,
                  );
                  if (confirmed) {
                    bloc.add(DeleteUserEvent(userId: user.id));
                  }
                },
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${user.role == 'student' ? 'طالب' : 'معلم'} - ${user.affiliation}',
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

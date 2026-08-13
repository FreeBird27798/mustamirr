import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/confirm_dialog.dart';
import '../../domain/entities/enrollment_request_entity.dart';
import '../bloc/enrollment/enrollment_bloc.dart';
import '../bloc/enrollment/enrollment_event.dart';
import '../bloc/enrollment/enrollment_state.dart';

class AdminEnrollmentPage extends StatelessWidget {
  const AdminEnrollmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EnrollmentBloc>()..add(LoadRequestsEvent()),
      child: const _EnrollmentView(),
    );
  }
}

class _EnrollmentView extends StatefulWidget {
  const _EnrollmentView();

  @override
  State<_EnrollmentView> createState() => _EnrollmentViewState();
}

class _EnrollmentViewState extends State<_EnrollmentView> {
  bool _showStudents = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          foregroundColor: AppColors.dark,
          centerTitle: true,
          title: const Text('طلبات الانتساب'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: BlocBuilder<EnrollmentBloc, EnrollmentState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Tabs(
                      showStudents: _showStudents,
                      studentsCount: state is EnrollmentLoaded
                          ? state.students.length
                          : 0,
                      teachersCount: state is EnrollmentLoaded
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

  Widget _buildBody(EnrollmentState state) {
    if (state is EnrollmentLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is EnrollmentError) {
      return Center(child: Text(state.message));
    } else if (state is EnrollmentLoaded) {
      final list = _showStudents ? state.students : state.teachers;
      if (list.isEmpty) {
        return const Center(child: Text('لا توجد طلبات'));
      }
      return ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _RequestCard(request: list[index]),
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
          _tab(
            'المعلمون ($teachersCount)',
            !showStudents,
            () => onChanged(false),
          ),
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

class _RequestCard extends StatelessWidget {
  final EnrollmentRequestEntity request;
  const _RequestCard({required this.request});

  bool get _isApproved => request.status == 'approved';

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
              Text(
                request.createdAt,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textGrey,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    request.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    request.affiliation,
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
                  request.name.isNotEmpty ? request.name[0] : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_isApproved)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.glow.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: Color(0xFF10B981), size: 18),
                  SizedBox(width: 6),
                  Text('معتمد', style: TextStyle(color: Color(0xFF10B981))),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final bloc = context.read<EnrollmentBloc>();
                      final confirmed = await showConfirmDialog(
                        context,
                        title: 'رفض الطلب',
                        message: 'هل أنت متأكد من رفض طلب "${request.name}"؟',
                        confirmText: 'رفض',
                        confirmColor: Colors.red,
                      );
                      if (confirmed) {
                        bloc.add(RejectRequestEvent(requestId: request.id));
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text('رفض'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final bloc = context.read<EnrollmentBloc>();
                      final confirmed = await showConfirmDialog(
                        context,
                        title: 'الموافقة على الطلب',
                        message:
                            'هل أنت متأكد من الموافقة على طلب "${request.name}"؟',
                        confirmText: 'موافقة',
                        confirmColor: const Color(0xFF10B981),
                      );
                      if (confirmed) {
                        bloc.add(ApproveRequestEvent(requestId: request.id));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('موافقة'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

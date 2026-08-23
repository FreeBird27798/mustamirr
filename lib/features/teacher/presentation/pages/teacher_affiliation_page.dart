import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../domain/entities/teacher_affiliation.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../cubit/teacher_affiliation_cubit.dart';

class TeacherAffiliationPage extends StatelessWidget {
  const TeacherAffiliationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeacherAffiliationCubit(sl<TeacherRepository>())..init(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('تحديد المؤسسة التعليمية'),
            backgroundColor: AppColors.background,
            elevation: 0,
            foregroundColor: AppColors.dark,
          ),
          body: BlocConsumer<TeacherAffiliationCubit, TeacherAffiliationState>(
            listener: (context, state) {
              if (state.submitted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تم إرسال طلب الانتساب. بانتظار موافقة الإدارة.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                context.pop();
              }
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.initialLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.existingStatus != null) {
                return _StatusView(status: state.existingStatus!);
              }
              return _AffiliationForm(state: state);
            },
          ),
        ),
      ),
    );
  }
}

class _AffiliationForm extends StatelessWidget {
  final TeacherAffiliationState state;
  const _AffiliationForm({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TeacherAffiliationCubit>();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        const Text(
          'اختر مؤسستك، والصفوف التي تدرّسها، وتخصصك، والمواد التي تقدّمها. '
          'وسيراجع طلبك مدير النظام.',
          style: TextStyle(fontSize: 14, color: AppColors.textGrey),
        ),
        const SizedBox(height: 24),

        // 1) Institution type
        _Dropdown<String>(
          label: 'نوع المؤسسة',
          value: state.selectedType,
          items: [
            for (final t in state.types)
              DropdownMenuItem(value: t.value, child: Text(t.label)),
          ],
          onChanged: (v) => v == null ? null : cubit.selectType(v),
        ),

        // 2) Institution
        if (state.selectedType != null) ...[
          const SizedBox(height: 16),
          _Dropdown<int>(
            label: 'المؤسسة',
            value: state.selectedInstitutionId,
            loading: state.stepLoading && state.institutions.isEmpty,
            items: [
              for (final i in state.institutions)
                DropdownMenuItem(value: i.id, child: Text(i.name)),
            ],
            onChanged: (v) => v == null ? null : cubit.selectInstitution(v),
          ),
        ],

        // 3) Academic levels (multi-select)
        if (state.selectedInstitutionId != null) ...[
          const SizedBox(height: 20),
          _MultiSelect(
            label: 'الصفوف / المستويات التي تدرّسها',
            loading: state.stepLoading && state.levels.isEmpty,
            options: [
              for (final l in state.levels) (id: l.id, name: l.name),
            ],
            selected: state.selectedLevelIds,
            onToggle: cubit.toggleLevel,
          ),
        ],

        // 4) Specialization (single, from the first-picked level)
        if (state.selectedLevelIds.isNotEmpty) ...[
          const SizedBox(height: 16),
          _Dropdown<int>(
            label: 'التخصص',
            value: state.selectedSpecializationId,
            loading: state.specLoading && state.specializations.isEmpty,
            items: [
              for (final s in state.specializations)
                DropdownMenuItem(value: s.id, child: Text(s.name)),
            ],
            onChanged: (v) => v == null ? null : cubit.selectSpecialization(v),
          ),
        ],

        // 5) Subjects (multi-select)
        if (state.selectedInstitutionId != null) ...[
          const SizedBox(height: 20),
          _MultiSelect(
            label: 'المواد التي تقدّمها',
            loading: false,
            options: [
              for (final s in state.subjects) (id: s.id, name: s.name),
            ],
            selected: state.selectedSubjectIds,
            onToggle: cubit.toggleSubject,
          ),
        ],

        const SizedBox(height: 32),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: (state.canSubmit && !state.submitting)
                ? cubit.submit
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: state.submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'إرسال الطلب',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }
}

class _MultiSelect extends StatelessWidget {
  final String label;
  final bool loading;
  final List<({int id, String name})> options;
  final Set<int> selected;
  final ValueChanged<int> onToggle;

  const _MultiSelect({
    required this.label,
    required this.loading,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        if (loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('جارٍ التحميل...', style: TextStyle(color: AppColors.textGrey)),
          )
        else if (options.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('لا توجد خيارات', style: TextStyle(color: AppColors.textGrey)),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final o in options)
                FilterChip(
                  label: Text(o.name),
                  selected: selected.contains(o.id),
                  onSelected: (_) => onToggle(o.id),
                  showCheckmark: true,
                  checkmarkColor: Colors.white,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.inputBackground,
                  labelStyle: TextStyle(
                    color: selected.contains(o.id)
                        ? Colors.white
                        : AppColors.dark,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool loading;

  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          hint: loading ? const Text('جارٍ التحميل...') : const Text('اختر...'),
          items: items,
          onChanged: loading ? null : onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 4,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusView extends StatelessWidget {
  final TeacherAffiliationStatusEntity status;
  const _StatusView({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    final IconData icon;
    switch (status.status) {
      case 'approved':
        color = Colors.green;
        label = 'تم قبول انتسابك';
        icon = Icons.check_circle_rounded;
        break;
      case 'rejected':
        color = Colors.red;
        label = 'تم رفض طلب الانتساب';
        icon = Icons.cancel_rounded;
        break;
      default:
        color = AppColors.amber;
        label = 'طلبك قيد المراجعة';
        icon = Icons.hourglass_top_rounded;
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        Icon(icon, color: color, size: 64),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 24),
        _row('المؤسسة', status.institutionName),
        _row('التخصص', status.specializationName),
        _row('الصفوف / المستويات', status.academicLevels),
        _row('المواد', status.subjects),
        if ((status.adminNote ?? '').isNotEmpty)
          _row('ملاحظة الإدارة', status.adminNote!),
      ],
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: AppColors.textGrey)),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

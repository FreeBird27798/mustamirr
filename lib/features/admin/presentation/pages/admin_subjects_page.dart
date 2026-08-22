import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/confirm_dialog.dart';
import '../../domain/entities/admin_subject_entity.dart';
import '../bloc/admin_subjects/admin_subjects_bloc.dart';
import '../bloc/admin_subjects/admin_subjects_event.dart';
import '../bloc/admin_subjects/admin_subjects_state.dart';

const _gradeOptions = [
  'الصف الأول الثانوي',
  'الصف الثاني الثانوي',
  'الصف الثالث الثانوي',
  'كل الصفوف',
];

class AdminSubjectsPage extends StatelessWidget {
  const AdminSubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminSubjectsBloc>()..add(LoadSubjectsEvent()),
      child: const _SubjectsView(),
    );
  }
}

class _SubjectsView extends StatefulWidget {
  const _SubjectsView();

  @override
  State<_SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<_SubjectsView> {
  final _nameController = TextEditingController();
  String? _selectedGrade;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _add() {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedGrade == null) return;
    context.read<AdminSubjectsBloc>().add(
      AddSubjectEvent(
        subject: AdminSubjectEntity(
          id: 0,
          name: name,
          grade: _selectedGrade!,
          lessonsCount: 0,
        ),
      ),
    );
    setState(() {
      _nameController.clear();
      _selectedGrade = null;
    });
  }

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
          title: const Text('إدارة المواد'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AddForm(
                  nameController: _nameController,
                  selectedGrade: _selectedGrade,
                  onGradeChanged: (v) => setState(() => _selectedGrade = v),
                  onAdd: _add,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<AdminSubjectsBloc, AdminSubjectsState>(
                    builder: (context, state) {
                      if (state is AdminSubjectsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AdminSubjectsError) {
                        return Center(child: Text(state.message));
                      } else if (state is AdminSubjectsLoaded) {
                        if (state.subjects.isEmpty) {
                          return const Center(child: Text('لا توجد مواد'));
                        }
                        return ListView.separated(
                          itemCount: state.subjects.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _SubjectCard(subject: state.subjects[index]),
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
    );
  }
}

class _AddForm extends StatelessWidget {
  final TextEditingController nameController;
  final String? selectedGrade;
  final ValueChanged<String?> onGradeChanged;
  final VoidCallback onAdd;

  const _AddForm({
    required this.nameController,
    required this.selectedGrade,
    required this.onGradeChanged,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'اسم المادة',
              hintStyle: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 13,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: selectedGrade,
            isExpanded: true,
            hint: const Text(
              'الصف',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
            items: _gradeOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onGradeChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('إضافة مادة'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final AdminSubjectEntity subject;
  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              final bloc = context.read<AdminSubjectsBloc>();
              final confirmed = await showConfirmDialog(
                context,
                title: 'حذف المادة',
                message: 'هل أنت متأكد من حذف "${subject.name}"؟',
                confirmText: 'حذف',
                confirmColor: Colors.red,
              );
              if (confirmed) {
                bloc.add(DeleteSubjectEvent(subjectId: subject.id));
              }
            },
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  subject.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  '${subject.grade} • ${subject.lessonsCount} درسًا',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

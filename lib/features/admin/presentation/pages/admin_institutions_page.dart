import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/confirm_dialog.dart';
import '../../domain/entities/institution_entity.dart';
import '../bloc/institutions/institutions_bloc.dart';
import '../bloc/institutions/institutions_event.dart';
import '../bloc/institutions/institutions_state.dart';

// The 4 tabs: (type key, label, name-hint, subtitle-hint)
const _tabs = [
  ('university', 'جامعات', 'اسم الجامعة', 'المدينة'),
  ('school', 'مدارس', 'اسم المدرسة', 'المدينة'),
  ('specialization', 'تخصصات', 'اسم التخصص', 'الجامعة - الدرجة'),
  ('grade', 'صفوف', 'اسم الصف', 'المدرسة'),
];

class AdminInstitutionsPage extends StatelessWidget {
  const AdminInstitutionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<InstitutionsBloc>()
            ..add(const LoadInstitutionsEvent(type: 'university')),
      child: const _InstitutionsView(),
    );
  }
}

class _InstitutionsView extends StatefulWidget {
  const _InstitutionsView();

  @override
  State<_InstitutionsView> createState() => _InstitutionsViewState();
}

class _InstitutionsViewState extends State<_InstitutionsView> {
  int _tabIndex = 0;
  final _nameController = TextEditingController();
  final _subtitleController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  void _selectTab(int i) {
    setState(() {
      _tabIndex = i;
      _nameController.clear();
      _subtitleController.clear();
    });
    context.read<InstitutionsBloc>().add(
      LoadInstitutionsEvent(type: _tabs[i].$1),
    );
  }

  void _add() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    context.read<InstitutionsBloc>().add(
      AddInstitutionEvent(
        institution: InstitutionEntity(
          id: 0,
          type: _tabs[_tabIndex].$1,
          name: name,
          subtitle: _subtitleController.text.trim(),
        ),
      ),
    );
    _nameController.clear();
    _subtitleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[_tabIndex];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          foregroundColor: AppColors.dark,
          centerTitle: true,
          title: const Text('إدارة المؤسسات'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TabsBar(index: _tabIndex, onChanged: _selectTab),
                const SizedBox(height: 16),
                _AddForm(
                  nameController: _nameController,
                  subtitleController: _subtitleController,
                  nameHint: tab.$3,
                  subtitleHint: tab.$4,
                  addLabel: 'إضافة ${_singular(tab.$2)}',
                  onAdd: _add,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<InstitutionsBloc, InstitutionsState>(
                    builder: (context, state) {
                      if (state is InstitutionsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is InstitutionsError) {
                        return Center(child: Text(state.message));
                      } else if (state is InstitutionsLoaded) {
                        if (state.institutions.isEmpty) {
                          return const Center(child: Text('لا توجد عناصر'));
                        }
                        return ListView.separated(
                          itemCount: state.institutions.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) => _InstitutionCard(
                            institution: state.institutions[index],
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
    );
  }

  String _singular(String plural) {
    switch (plural) {
      case 'جامعات':
        return 'جامعة';
      case 'مدارس':
        return 'مدرسة';
      case 'تخصصات':
        return 'تخصص';
      case 'صفوف':
        return 'صف';
      default:
        return plural;
    }
  }
}

class _TabsBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _TabsBar({required this.index, required this.onChanged});

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
          for (var i = 0; i < _tabs.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: i == index ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _tabs[i].$2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: i == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: i == index
                          ? AppColors.primary
                          : AppColors.textGrey,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController subtitleController;
  final String nameHint;
  final String subtitleHint;
  final String addLabel;
  final VoidCallback onAdd;

  const _AddForm({
    required this.nameController,
    required this.subtitleController,
    required this.nameHint,
    required this.subtitleHint,
    required this.addLabel,
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
          _field(nameController, nameHint),
          const SizedBox(height: 10),
          _field(subtitleController, subtitleHint),
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
              label: Text(addLabel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _InstitutionCard extends StatelessWidget {
  final InstitutionEntity institution;
  const _InstitutionCard({required this.institution});

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
              final bloc = context.read<InstitutionsBloc>();
              final confirmed = await showConfirmDialog(
                context,
                title: 'حذف',
                message: 'هل أنت متأكد من حذف "${institution.name}"؟',
                confirmText: 'حذف',
                confirmColor: Colors.red,
              );
              if (confirmed) {
                bloc.add(DeleteInstitutionEvent(institutionId: institution.id));
              }
            },
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  institution.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (institution.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    institution.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

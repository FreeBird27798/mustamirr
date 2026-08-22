import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../domain/entities/lesson_content_entity.dart';
import '../../domain/entities/teacher_lesson_entity.dart';

/// Add (lesson == null) or Edit (lesson != null) a teacher lesson.
/// On save, pops with the resulting TeacherLessonEntity; the caller
/// (TeacherLessonsPage) dispatches the Add/Update event.
class ManageLessonPage extends StatefulWidget {
  final TeacherLessonEntity? lesson;
  const ManageLessonPage({super.key, this.lesson});

  @override
  State<ManageLessonPage> createState() => _ManageLessonPageState();
}

// Fixed option lists for the mock. In Phase 6 these come from the API
// (the teacher's actual subjects/grades).
const _subjectOptions = [
  'الرياضيات',
  'الفيزياء',
  'أخلاقيات المهنة',
  'اللياقة البدنية',
  'أمن المعلومات',
  'اللغة الإنجليزية',
];

const _gradeOptions = [
  'الصف الأول الثانوي',
  'الصف الثاني الثانوي',
  'الصف الثالث الثانوي',
  'بكالوريوس',
];

class _ManageLessonPageState extends State<ManageLessonPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  String? _selectedSubject;
  String? _selectedGrade;

  // Each content item = its own text controller.
  late final List<TextEditingController> _contentControllers;

  bool get _isEditing => widget.lesson != null;

  @override
  void initState() {
    super.initState();
    final l = widget.lesson;
    _titleController = TextEditingController(text: l?.title ?? '');
    _descriptionController = TextEditingController(text: l?.description ?? '');
    // Only preselect if the existing value is one of the known options.
    _selectedSubject = _subjectOptions.contains(l?.subject) ? l!.subject : null;
    _selectedGrade = _gradeOptions.contains(l?.grade) ? l!.grade : null;
    _contentControllers = (l?.contents ?? const [])
        .map((c) => TextEditingController(text: c.body))
        .toList();
    if (_contentControllers.isEmpty) {
      _contentControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final c in _contentControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addContentField() {
    setState(() => _contentControllers.add(TextEditingController()));
  }

  void _removeContentField(int index) {
    setState(() {
      _contentControllers[index].dispose();
      _contentControllers.removeAt(index);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final contents = <LessonContentEntity>[];
    for (var i = 0; i < _contentControllers.length; i++) {
      final body = _contentControllers[i].text.trim();
      if (body.isNotEmpty) {
        contents.add(
          LessonContentEntity(title: 'المحتوى رقم ${i + 1}', body: body),
        );
      }
    }

    final result = TeacherLessonEntity(
      id: widget.lesson?.id ?? 0, // 0 → new; datasource assigns real id
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      subject: _selectedSubject ?? '',
      grade: _selectedGrade ?? '',
      // TODO: real file picker (Phase 6) — mock keeps existing type/size or defaults
      fileType: widget.lesson?.fileType ?? 'pdf',
      fileSizeMb: widget.lesson?.fileSizeMb ?? 2.0,
      contents: contents,
    );

    context.pop(result);
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
          title: Text(_isEditing ? 'تعديل الدرس' : 'إضافة درس'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                _Label('عنوان الدرس'),
                _Field(
                  controller: _titleController,
                  hint: 'مثال : قوانين نيوتن للحركة',
                  validator: _required,
                ),
                const SizedBox(height: 16),
                _Label('الوصف'),
                _Field(
                  controller: _descriptionController,
                  hint: 'اكتب وصفًا مختصرا',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _Label('المادة او المساق'),
                _Dropdown(
                  value: _selectedSubject,
                  hint: 'اختر المادة',
                  items: _subjectOptions,
                  onChanged: (v) => setState(() => _selectedSubject = v),
                  validator: (v) => v == null ? 'الرجاء اختيار المادة' : null,
                ),
                const SizedBox(height: 16),
                _Label('الصف او الشعبة'),
                _Dropdown(
                  value: _selectedGrade,
                  hint: 'اختر الصف',
                  items: _gradeOptions,
                  onChanged: (v) => setState(() => _selectedGrade = v),
                ),
                const SizedBox(height: 16),
                const _UploadArea(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _addContentField,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('اضافة'),
                    ),
                    const Text(
                      'المحتوى',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._buildContentFields(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text('حفظ'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text('إلغاء'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContentFields() {
    final widgets = <Widget>[];
    for (var i = 0; i < _contentControllers.length; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_contentControllers.length > 1)
                    IconButton(
                      onPressed: () => _removeContentField(i),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                  Text(
                    'المحتوى رقم ${i + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              _Field(controller: _contentControllers[i], hint: 'اكتب المحتوى'),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textAlign: TextAlign.right,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const _Dropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      validator: validator,
      hint: Text(
        hint,
        style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _UploadArea extends StatelessWidget {
  const _UploadArea();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.glow.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.glow.withValues(alpha: 0.4),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.upload_rounded, color: AppColors.primary, size: 32),
          const SizedBox(height: 8),
          const Text(
            'اسحب وأفلت او اضغط للتحميل',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'PDF, MP4, DOC حتى 200MB',
            style: TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
          // TODO: real file picker wired in Phase 6 (mock upload area for now)
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/file_type_style.dart';
import '../../../teacher/domain/repositories/teacher_repository.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/repositories/student_repository.dart';
import '../cubit/search_cubit.dart';

class SearchPage extends StatelessWidget {
  /// Same screen for both roles — only the repository (endpoint prefix) differs.
  final bool forTeacher;
  const SearchPage({super.key, this.forTeacher = false});

  @override
  Widget build(BuildContext context) {
    final SearchRepository repo = forTeacher
        ? sl<TeacherRepository>()
        : sl<StudentRepository>();
    return BlocProvider(
      create: (_) => SearchCubit(repo)..loadRecent(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          foregroundColor: AppColors.dark,
          title: const Text('البحث'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: const _SearchField(),
              ),
              const Expanded(child: _SearchBody()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    return TextField(
      autofocus: true,
      textInputAction: TextInputAction.search,
      onSubmitted: cubit.search,
      decoration: InputDecoration(
        hintText: 'ابحث عن درس... (حرفين على الأقل)',
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!state.searched) {
          return _RecentSearches(recent: state.recent);
        }
        if (state.results.isEmpty) {
          return const Center(child: Text('لا توجد نتائج'));
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: state.results.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _ResultTile(lesson: state.results[i]),
        );
      },
    );
  }
}

class _RecentSearches extends StatelessWidget {
  final List<String> recent;
  const _RecentSearches({required this.recent});

  @override
  Widget build(BuildContext context) {
    if (recent.isEmpty) {
      return const Center(
        child: Text(
          'ابحث عن الدروس بالعنوان',
          style: TextStyle(color: AppColors.textGrey),
        ),
      );
    }
    final cubit = context.read<SearchCubit>();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'عمليات بحث سابقة',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final term in recent)
              ActionChip(
                label: Text(term),
                backgroundColor: AppColors.inputBackground,
                onPressed: () => cubit.search(term),
              ),
          ],
        ),
      ],
    );
  }
}

class _ResultTile extends StatelessWidget {
  final LessonEntity lesson;
  const _ResultTile({required this.lesson});

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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: FileTypeStyle.colorFor(lesson.fileType),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                FileTypeStyle.labelFor(lesson.fileType),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lesson.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  lesson.teacherName,
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

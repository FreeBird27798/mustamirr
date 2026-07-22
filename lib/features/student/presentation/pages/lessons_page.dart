import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/file_type_style.dart';
import '../../domain/entities/lesson_entity.dart';
import '../bloc/lessons/lessons_bloc.dart';
import '../bloc/lessons/lessons_event.dart';
import '../bloc/lessons/lessons_state.dart';

class LessonsPage extends StatelessWidget {
  final int subjectId;
  const LessonsPage({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<LessonsBloc>()..add(LoadLessonsEvent(subjectId: subjectId)),
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
                      Expanded(
                        child: BlocBuilder<LessonsBloc, LessonsState>(
                          builder: (context, state) {
                            final title = state is LessonsLoaded &&
                                    state.lessons.isNotEmpty
                                ? state.lessons.first.subjectName
                                : 'الدروس';
                            return Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<LessonsBloc, LessonsState>(
                      builder: (context, state) {
                        if (state is LessonsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is LessonsError) {
                          return Center(child: Text(state.message));
                        } else if (state is LessonsLoaded) {
                          if (state.lessons.isEmpty) {
                            return const Center(child: Text('لا توجد دروس بعد'));
                          }
                          return ListView.separated(
                            itemCount: state.lessons.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, index) =>
                                _LessonRow(lesson: state.lessons[index]),
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

class _LessonRow extends StatelessWidget {
  final LessonEntity lesson;
  const _LessonRow({required this.lesson});

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
            onPressed: () {
              context.read<LessonsBloc>().add(
                DownloadLessonEvent(lessonId: lesson.id),
              );
            },
            icon: Icon(
              lesson.isDownloaded
                  ? Icons.download_done_rounded
                  : Icons.download_outlined,
              color: lesson.isDownloaded ? AppColors.primary : AppColors.textGrey,
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<LessonsBloc>().add(
                ToggleFavoriteEvent(lessonId: lesson.id),
              );
            },
            icon: Icon(
              lesson.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: lesson.isFavorite ? Colors.red : AppColors.textGrey,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lesson.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  lesson.teacherName,
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${lesson.pageCount} صفحة',
                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textGrey),
                    const SizedBox(width: 12),
                    Text(
                      '${lesson.rating}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star_rounded, size: 14, color: AppColors.amber),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: FileTypeStyle.colorFor(lesson.fileType),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                FileTypeStyle.labelFor(lesson.fileType),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

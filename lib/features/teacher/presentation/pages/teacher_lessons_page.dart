import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../domain/entities/teacher_lesson_entity.dart';
import '../bloc/teacher_lessons/teacher_lessons_bloc.dart';
import '../bloc/teacher_lessons/teacher_lessons_event.dart';
import '../bloc/teacher_lessons/teacher_lessons_state.dart';
import '../widgets/teacher_lesson_card.dart';

class TeacherLessonsPage extends StatelessWidget {
  const TeacherLessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TeacherLessonsBloc>()..add(LoadMyLessonsEvent()),
      child: const _TeacherLessonsView(),
    );
  }
}

class _TeacherLessonsView extends StatelessWidget {
  const _TeacherLessonsView();

  Future<void> _openForm(
    BuildContext context, {
    TeacherLessonEntity? lesson,
  }) async {
    final bloc = context.read<TeacherLessonsBloc>();
    final result = await context.push<TeacherLessonEntity>(
      AppRoutes.teacherManageLesson,
      extra: lesson,
    );
    if (result != null) {
      if (lesson == null) {
        bloc.add(AddLessonRequested(lesson: result));
      } else {
        bloc.add(UpdateLessonRequested(lesson: result));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'لوحة المعلم',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _openForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة درس جديد'),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<TeacherLessonsBloc, TeacherLessonsState>(
                    builder: (context, state) {
                      if (state is TeacherLessonsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TeacherLessonsError) {
                        return Center(child: Text(state.message));
                      } else if (state is TeacherLessonsLoaded) {
                        if (state.lessons.isEmpty) {
                          return const Center(child: Text('لا توجد دروس بعد'));
                        }
                        return ListView.separated(
                          itemCount: state.lessons.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final lesson = state.lessons[index];
                            return TeacherLessonCard(
                              lesson: lesson,
                              onEdit: () => _openForm(context, lesson: lesson),
                              onDelete: () => context
                                  .read<TeacherLessonsBloc>()
                                  .add(DeleteLessonEvent(lessonId: lesson.id)),
                            );
                          },
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

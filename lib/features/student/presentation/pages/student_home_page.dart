import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/coming_soon.dart';
import '../../../../core/utils/file_type_style.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/subject_entity.dart';
import '../cubit/notification_badge_cubit.dart';
import '../bloc/student_home/student_home_bloc.dart';
import '../bloc/student_home/student_home_event.dart';
import '../bloc/student_home/student_home_state.dart';
import '../widgets/student_header.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // refresh the header's unread-notifications dot when home opens
        context.read<NotificationBadgeCubit>().load();
        return sl<StudentHomeBloc>()..add(LoadHomeDataEvent());
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: BlocBuilder<StudentHomeBloc, StudentHomeState>(
              builder: (context, state) {
                if (state is StudentHomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StudentHomeError) {
                  return Center(child: Text(state.message));
                } else if (state is StudentHomeLoaded) {
                  return _HomeContent(
                    subjects: state.subjects,
                    recentLessons: state.recentLessons,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final List<SubjectEntity> subjects;
  final List<LessonEntity> recentLessons;

  const _HomeContent({required this.subjects, required this.recentLessons});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        const StudentHeader(),
        const SizedBox(height: 20),
        const _InstitutionBanner(),
        const SizedBox(height: 20),
        if (recentLessons.isNotEmpty) ...[
          _ContinueLessonCard(lesson: recentLessons.first),
          const SizedBox(height: 24),
        ],
        _SectionHeader(title: 'المواد الدراسية'),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: subjects.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _SubjectCard(subject: subjects[index]),
          ),
        ),
        const SizedBox(height: 24),
        _SectionHeader(title: 'أحدث الدروس'),
        const SizedBox(height: 12),
        ...recentLessons.map(
          (lesson) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _LessonCard(lesson: lesson),
          ),
        ),
      ],
    );
  }
}

class _InstitutionBanner extends StatelessWidget {
  const _InstitutionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.glow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.chevron_left_rounded, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'أكمل تحديد مؤسستك التعليمية',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2),
                Text(
                  'اختر مدرستك أو جامعتك لربط الدروس بك',
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school_outlined, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _ContinueLessonCard extends StatelessWidget {
  final LessonEntity lesson;

  const _ContinueLessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lesson.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${lesson.subjectName}. ${lesson.teacherName}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () => showComingSoon(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('متابعة'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () => showComingSoon(context),
          child: const Text(
            'عرض الكل',
            style: TextStyle(color: AppColors.glow, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final SubjectEntity subject;
  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Material(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(AppRoutes.lessonsPath(subject.id)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.menu_book_rounded, color: AppColors.primary),
                const SizedBox(height: 8),
                Text(
                  '${subject.lessonCount}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'درسًا',
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  subject.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final LessonEntity lesson;
  const _LessonCard({required this.lesson});

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
          const SizedBox(width: 12),
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
          IconButton(
            onPressed:() => context.read<StudentHomeBloc>().add(ToggleFavoriteEvent(lessonId: lesson.id)),
            icon: Icon(lesson.isFavorite ? Icons.favorite : Icons.favorite_border),
            color: lesson.isFavorite ? Colors.red : AppColors.textGrey,
          ),
        ],
      ),
    );
  }
}
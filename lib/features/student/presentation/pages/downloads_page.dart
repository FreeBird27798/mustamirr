import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/coming_soon.dart';
import '../../../../core/utils/file_type_style.dart';
import '../../domain/entities/lesson_entity.dart';
import '../bloc/downloads/downloads_bloc.dart';
import '../bloc/downloads/downloads_event.dart';
import '../bloc/downloads/downloads_state.dart';
import '../widgets/student_header.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DownloadsBloc>()..add(LoadDownloadsEvent()),
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
                  const StudentHeader(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BlocBuilder<DownloadsBloc, DownloadsState>(
                      builder: (context, state) {
                        if (state is DownloadsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is DownloadsError) {
                          return Center(child: Text(state.message));
                        } else if (state is DownloadsLoaded) {
                          if (state.downloads.isEmpty) {
                            return const _EmptyDownloads();
                          }
                          return _DownloadsList(downloads: state.downloads);
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

class _EmptyDownloads extends StatelessWidget {
  const _EmptyDownloads();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.folder_off_outlined,
            size: 72,
            color: AppColors.textGrey,
          ),
          const SizedBox(height: 20),
          const Text(
            'لا توجد ملفات محملة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'حمّل أي درس ليظهر هنا ويصبح متاحًا دون إنترنت',
            style: TextStyle(fontSize: 13, color: AppColors.textGrey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => showComingSoon(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('تصفّح الدروس'),
          ),
        ],
      ),
    );
  }
}

class _DownloadsList extends StatelessWidget {
  final List<LessonEntity> downloads;
  const _DownloadsList({required this.downloads});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${downloads.length} دروسًا محملة',
          style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: downloads.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _DownloadedLessonCard(lesson: downloads[index]),
          ),
        ),
      ],
    );
  }
}

class _DownloadedLessonCard extends StatelessWidget {
  final LessonEntity lesson;
  const _DownloadedLessonCard({required this.lesson});

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
              context.read<DownloadsBloc>().add(
                DeleteDownloadEvent(lessonId: lesson.id),
              );
            },
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          ),
          IconButton(
            onPressed: () => showComingSoon(context),
            icon: const Icon(Icons.visibility_outlined, color: AppColors.glow),
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
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

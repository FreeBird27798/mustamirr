import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/coming_soon.dart';
import '../../../../core/utils/file_type_style.dart';
import '../../domain/entities/lesson_entity.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';
import '../widgets/student_header.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FavoritesBloc>()..add(LoadFavoritesEvent()),
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
                    child: BlocBuilder<FavoritesBloc, FavoritesState>(
                      builder: (context, state) {
                        if (state is FavoritesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is FavoritesError) {
                          return Center(child: Text(state.message));
                        } else if (state is FavoritesLoaded) {
                          if (state.favorites.isEmpty) {
                            return const _EmptyFavorites();
                          }
                          return _FavoritesList(favorites: state.favorites);
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

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_stories_outlined,
            size: 72,
            color: AppColors.textGrey,
          ),
          const SizedBox(height: 20),
          const Text(
            'لا توجد دروس في المفضلة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'اضغط على أيقونة القلب في أي درس لإضافته هنا',
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

class _FavoritesList extends StatelessWidget {
  final List<LessonEntity> favorites;
  const _FavoritesList({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${favorites.length} دروسًا محفوظًا',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
            const Text(
              'الأحدث  ⇅',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: favorites.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _FavoriteLessonCard(lesson: favorites[index]),
          ),
        ),
      ],
    );
  }
}

class _FavoriteLessonCard extends StatelessWidget {
  final LessonEntity lesson;
  const _FavoriteLessonCard({required this.lesson});

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
              context.read<FavoritesBloc>().add(
                RemoveFavoriteEvent(lessonId: lesson.id),
              );
            },
            icon: const Icon(Icons.favorite, color: Colors.red),
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
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${lesson.pageCount} صفحة',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppColors.textGrey,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${lesson.rating}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: AppColors.amber,
                    ),
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

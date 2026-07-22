import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/download_lesson_usecase.dart';
import '../../../domain/usecases/get_lessons_usecase.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';
import 'lessons_event.dart';
import 'lessons_state.dart';

class LessonsBloc extends Bloc<LessonsEvent, LessonsState> {
  final GetLessonsUseCase getLessonsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final DownloadLessonUseCase downloadLessonUseCase;

  int? _currentSubjectId;

  LessonsBloc({
    required this.getLessonsUseCase,
    required this.toggleFavoriteUseCase,
    required this.downloadLessonUseCase,
  }) : super(LessonsInitial()) {
    on<LoadLessonsEvent>(_onLoadLessons);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<DownloadLessonEvent>(_onDownloadLesson);
  }

  Future<void> _onLoadLessons(
    LoadLessonsEvent event,
    Emitter<LessonsState> emit,
  ) async {
    _currentSubjectId = event.subjectId;
    emit(LessonsLoading());
    final result = await getLessonsUseCase(event.subjectId);
    result.fold(
      (failure) => emit(LessonsError(message: failure.message)),
      (lessons) => emit(LessonsLoaded(lessons: lessons)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<LessonsState> emit,
  ) async {
    final result = await toggleFavoriteUseCase(event.lessonId);
    await result.fold(
      (failure) async => emit(LessonsError(message: failure.message)),
      (_) async {
        if (_currentSubjectId != null) {
          add(LoadLessonsEvent(subjectId: _currentSubjectId!));
        }
      },
    );
  }

  Future<void> _onDownloadLesson(
    DownloadLessonEvent event,
    Emitter<LessonsState> emit,
  ) async {
    final result = await downloadLessonUseCase(event.lessonId);
    await result.fold(
      (failure) async => emit(LessonsError(message: failure.message)),
      (_) async {
        if (_currentSubjectId != null) {
          add(LoadLessonsEvent(subjectId: _currentSubjectId!));
        }
      },
    );
  }
}

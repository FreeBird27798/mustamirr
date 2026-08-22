import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mustamirr/features/student/domain/usecases/toggle_favorite_usecase.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_recent_lessons_usecase.dart';
import '../../../domain/usecases/get_subjects_usecase.dart';
import 'student_home_event.dart';
import 'student_home_state.dart';

class StudentHomeBloc extends Bloc<StudentHomeEvent, StudentHomeState> {
  final GetSubjectsUseCase getSubjectsUseCase;
  final GetRecentLessonsUseCase getRecentLessonsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  StudentHomeBloc({
    required this.getSubjectsUseCase,
    required this.getRecentLessonsUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(StudentHomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }
  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<StudentHomeState> emit,
  ) async {
    emit(StudentHomeLoading());
    await _fetchAndEmit(emit);
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<StudentHomeState> emit,
  ) async {
    final result = await toggleFavoriteUseCase(event.lessonId);
    await result.fold(
      (failure) async => emit(StudentHomeError(message: failure.message)),
      (_) async => await _fetchAndEmit(emit),
    );
  }

  Future<void> _fetchAndEmit(Emitter<StudentHomeState> emit) async {
    final subjectsFuture = getSubjectsUseCase(NoParams());
    final recentLessonsFuture = getRecentLessonsUseCase(NoParams());

    final subjectsResult = await subjectsFuture;
    final recentLessonsResult = await recentLessonsFuture;

    subjectsResult.fold(
      (failure) => emit(StudentHomeError(message: failure.message)),
      (subjects) {
        recentLessonsResult.fold(
          (failure) => emit(StudentHomeError(message: failure.message)),
          (lessons) => emit(
            StudentHomeLoaded(subjects: subjects, recentLessons: lessons),
          ),
        );
      },
    );
  }
}

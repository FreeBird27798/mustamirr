import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/add_lesson_usecase.dart';
import '../../../domain/usecases/delete_lesson_usecase.dart';
import '../../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../../domain/usecases/get_my_lessons_usecase.dart';
import '../../../domain/usecases/update_lesson_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;
  final GetMyLessonsUseCase getMyLessonsUseCase;
  final AddLessonUseCase addLessonUseCase;
  final UpdateLessonUseCase updateLessonUseCase;
  final DeleteLessonUseCase deleteLessonUseCase;

  DashboardBloc({
    required this.getDashboardStatsUseCase,
    required this.getMyLessonsUseCase,
    required this.addLessonUseCase,
    required this.updateLessonUseCase,
    required this.deleteLessonUseCase,
  }) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<AddLessonRequested>(_onAddLesson);
    on<UpdateLessonRequested>(_onUpdateLesson);
    on<DeleteLessonRequested>(_onDeleteLesson);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    await _fetchAndEmit(emit);
  }

  Future<void> _onAddLesson(
    AddLessonRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await addLessonUseCase(event.lesson);
    await result.fold(
      (failure) async => emit(DashboardError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _onUpdateLesson(
    UpdateLessonRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await updateLessonUseCase(event.lesson);
    await result.fold(
      (failure) async => emit(DashboardError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _onDeleteLesson(
    DeleteLessonRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await deleteLessonUseCase(event.lessonId);
    await result.fold(
      (failure) async => emit(DashboardError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  /// Fetches stats + lessons in parallel and emits Loaded/Error.
  /// Does NOT emit Loading — callers decide whether to show a spinner.
  Future<void> _fetchAndEmit(Emitter<DashboardState> emit) async {
    final statsFuture = getDashboardStatsUseCase(NoParams());
    final lessonsFuture = getMyLessonsUseCase(NoParams());

    final statsResult = await statsFuture;
    final lessonsResult = await lessonsFuture;

    statsResult.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (stats) {
        lessonsResult.fold(
          (failure) => emit(DashboardError(message: failure.message)),
          (lessons) => emit(
            DashboardLoaded(
              stats: stats,
              recentLessons: lessons.take(3).toList(),
            ),
          ),
        );
      },
    );
  }
}

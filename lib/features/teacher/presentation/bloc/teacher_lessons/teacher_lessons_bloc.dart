import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/add_lesson_usecase.dart';
import '../../../domain/usecases/delete_lesson_usecase.dart';
import '../../../domain/usecases/get_my_lessons_usecase.dart';
import '../../../domain/usecases/update_lesson_usecase.dart';
import 'teacher_lessons_event.dart';
import 'teacher_lessons_state.dart';

class TeacherLessonsBloc
    extends Bloc<TeacherLessonsEvent, TeacherLessonsState> {
  final GetMyLessonsUseCase getMyLessonsUseCase;
  final DeleteLessonUseCase deleteLessonUseCase;
  final AddLessonUseCase addLessonUseCase;
  final UpdateLessonUseCase updateLessonUseCase;

  TeacherLessonsBloc({
    required this.getMyLessonsUseCase,
    required this.deleteLessonUseCase,
    required this.addLessonUseCase,
    required this.updateLessonUseCase,
  }) : super(TeacherLessonsInitial()) {
    on<LoadMyLessonsEvent>(_onLoadMyLessons);
    on<DeleteLessonEvent>(_onDeleteLesson);
    on<AddLessonRequested>(_onAddLesson);
    on<UpdateLessonRequested>(_onUpdateLesson);
  }

  Future<void> _onLoadMyLessons(
    LoadMyLessonsEvent event,
    Emitter<TeacherLessonsState> emit,
  ) async {
    emit(TeacherLessonsLoading());
    await _fetchAndEmit(emit);
  }

  Future<void> _onDeleteLesson(
    DeleteLessonEvent event,
    Emitter<TeacherLessonsState> emit,
  ) async {
    final result = await deleteLessonUseCase(event.lessonId);
    await result.fold(
      (failure) async => emit(TeacherLessonsError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _onAddLesson(
    AddLessonRequested event,
    Emitter<TeacherLessonsState> emit,
  ) async {
    final result = await addLessonUseCase(event.lesson);
    await result.fold(
      (failure) async => emit(TeacherLessonsError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _onUpdateLesson(
    UpdateLessonRequested event,
    Emitter<TeacherLessonsState> emit,
  ) async {
    final result = await updateLessonUseCase(event.lesson);
    await result.fold(
      (failure) async => emit(TeacherLessonsError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  /// Fetches lessons and emits Loaded/Error without a Loading spinner —
  /// used after mutations so the list doesn't flash.
  Future<void> _fetchAndEmit(Emitter<TeacherLessonsState> emit) async {
    final result = await getMyLessonsUseCase(NoParams());
    result.fold(
      (failure) => emit(TeacherLessonsError(message: failure.message)),
      (lessons) => emit(TeacherLessonsLoaded(lessons: lessons)),
    );
  }
}

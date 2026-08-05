import 'package:equatable/equatable.dart';

import '../../../domain/entities/teacher_lesson_entity.dart';

abstract class TeacherLessonsState extends Equatable {
  const TeacherLessonsState();

  @override
  List<Object?> get props => [];
}

class TeacherLessonsInitial extends TeacherLessonsState {}

class TeacherLessonsLoading extends TeacherLessonsState {}

class TeacherLessonsLoaded extends TeacherLessonsState {
  final List<TeacherLessonEntity> lessons;
  const TeacherLessonsLoaded({required this.lessons});

  @override
  List<Object?> get props => [lessons];
}

class TeacherLessonsError extends TeacherLessonsState {
  final String message;
  const TeacherLessonsError({required this.message});

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

import '../../../domain/entities/teacher_lesson_entity.dart';

abstract class TeacherLessonsEvent extends Equatable {
  const TeacherLessonsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyLessonsEvent extends TeacherLessonsEvent {}

class DeleteLessonEvent extends TeacherLessonsEvent {
  final int lessonId;
  const DeleteLessonEvent({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}

class AddLessonRequested extends TeacherLessonsEvent {
  final TeacherLessonEntity lesson;
  const AddLessonRequested({required this.lesson});

  @override
  List<Object?> get props => [lesson];
}

class UpdateLessonRequested extends TeacherLessonsEvent {
  final TeacherLessonEntity lesson;
  const UpdateLessonRequested({required this.lesson});

  @override
  List<Object?> get props => [lesson];
}

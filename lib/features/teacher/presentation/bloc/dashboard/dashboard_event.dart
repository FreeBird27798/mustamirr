import 'package:equatable/equatable.dart';

import '../../../domain/entities/teacher_lesson_entity.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardEvent extends DashboardEvent {}

class AddLessonRequested extends DashboardEvent {
  final TeacherLessonEntity lesson;
  const AddLessonRequested({required this.lesson});

  @override
  List<Object?> get props => [lesson];
}

class UpdateLessonRequested extends DashboardEvent {
  final TeacherLessonEntity lesson;
  const UpdateLessonRequested({required this.lesson});

  @override
  List<Object?> get props => [lesson];
}

class DeleteLessonRequested extends DashboardEvent {
  final int lessonId;
  const DeleteLessonRequested({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}

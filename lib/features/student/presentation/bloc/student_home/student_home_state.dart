import 'package:equatable/equatable.dart';

import '../../../domain/entities/lesson_entity.dart';
import '../../../domain/entities/subject_entity.dart';

abstract class StudentHomeState extends Equatable {
  const StudentHomeState();

  @override
  List<Object?> get props => [];
}

class StudentHomeInitial extends StudentHomeState {}

class StudentHomeLoading extends StudentHomeState {}

class StudentHomeLoaded extends StudentHomeState {
  final List<SubjectEntity> subjects;
  final List<LessonEntity> recentLessons;
  const StudentHomeLoaded({
    required this.subjects,
    required this.recentLessons,
  });
  @override
  List<Object?> get props => [subjects, recentLessons];
}

class StudentHomeError extends StudentHomeState {
  final String message;
  const StudentHomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

import '../../../domain/entities/teacher_lesson_entity.dart';
import '../../../domain/entities/teacher_stats_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final TeacherStatsEntity stats;
  final List<TeacherLessonEntity> recentLessons;

  const DashboardLoaded({required this.stats, required this.recentLessons});

  @override
  List<Object?> get props => [stats, recentLessons];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}

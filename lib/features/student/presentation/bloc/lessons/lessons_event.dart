import 'package:equatable/equatable.dart';

abstract class LessonsEvent extends Equatable {}

class LoadLessonsEvent extends LessonsEvent {
  final int subjectId;

  LoadLessonsEvent({required this.subjectId});

  @override
  List<Object?> get props => [subjectId];
}

class ToggleFavoriteEvent extends LessonsEvent {
  final int lessonId;

  ToggleFavoriteEvent({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}

class DownloadLessonEvent extends LessonsEvent {
  final int lessonId;

  DownloadLessonEvent({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}

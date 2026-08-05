import 'package:equatable/equatable.dart';
import 'lesson_content_entity.dart';

class TeacherLessonEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String subject;
  final String grade;
  final String fileType; // pdf, video, word, doc
  final double fileSizeMb;
  final List<LessonContentEntity> contents;

  const TeacherLessonEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.grade,
    required this.fileType,
    required this.fileSizeMb,
    required this.contents,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    subject,
    grade,
    fileType,
    fileSizeMb,
    contents,
  ];
}

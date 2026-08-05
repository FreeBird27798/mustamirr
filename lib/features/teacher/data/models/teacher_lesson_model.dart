import '../../domain/entities/teacher_lesson_entity.dart';
import 'lesson_content_model.dart';

class TeacherLessonModel extends TeacherLessonEntity {
  const TeacherLessonModel({
    required super.id,
    required super.title,
    required super.description,
    required super.subject,
    required super.grade,
    required super.fileType,
    required super.fileSizeMb,
    required super.contents,
  });

  factory TeacherLessonModel.fromJson(Map<String, dynamic> json) {
    return TeacherLessonModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      subject: json['subject'] as String,
      grade: json['grade'] as String,
      fileType: json['file_type'] as String,
      fileSizeMb: (json['file_size_mb'] as num).toDouble(),
      contents: (json['contents'] as List<dynamic>)
          .map((e) => LessonContentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'grade': grade,
      'file_type': fileType,
      'file_size_mb': fileSizeMb,
      'contents': contents
          .map((e) => LessonContentModel.fromEntity(e).toJson())
          .toList(),
    };
  }
}

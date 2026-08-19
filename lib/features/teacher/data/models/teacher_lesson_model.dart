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

  /// The teacher's own lesson. Robust to missing fields since the list endpoint
  /// returns summary items (and `subject` may be a nested object). `contents`
  /// defaults to empty when the list shape omits it.
  factory TeacherLessonModel.fromJson(Map<String, dynamic> json) {
    final subject = json['subject'];
    final contentsRaw = json['contents'];
    return TeacherLessonModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      subject:
          (subject is Map
                  ? (subject['title'] ?? '')
                  : (subject ?? json['subject_name'] ?? ''))
              as String,
      grade: (json['grade'] ?? json['academic_level_name'] ?? '') as String,
      fileType: (json['content_type'] ?? json['file_type'] ?? '') as String,
      fileSizeMb: (json['file_size_mb'] as num?)?.toDouble() ?? 0.0,
      contents: contentsRaw is List
          ? contentsRaw
                .map(
                  (e) => LessonContentModel.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList()
          : const [],
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

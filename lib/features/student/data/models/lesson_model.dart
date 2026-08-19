import '../../domain/entities/lesson_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.title,
    required super.teacherName,
    required super.subjectName,
    required super.fileType,
    required super.rating,
    required super.pageCount,
    required super.date,
    required super.isFavorite,
    required super.isDownloaded,
    required super.description,
    required super.fileUrl,
  });

  /// Handles both the list shape (favorites/downloads/subject lessons) and the
  /// detail shape (`/student/lessons/<id>`), where instructor/subject are nested
  /// objects and extra fields (description, file_path) appear. Missing fields
  /// fall back to sensible defaults since list responses omit some of them.
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    final instructor = json['instructor'];
    final subject = json['subject'];
    return LessonModel(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      teacherName:
          (json['instructor_name'] ??
                  (instructor is Map ? instructor['name'] : null) ??
                  '')
              as String,
      subjectName:
          (subject is Map
                  ? (subject['title'] ?? '')
                  : (json['subject_name'] ?? ''))
              as String,
      fileType: (json['content_type'] ?? '') as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      pageCount: (json['page_count'] as num?)?.toInt() ?? 0,
      date: (json['published_at'] ?? '') as String,
      isFavorite: (json['is_favorite'] as bool?) ?? false,
      isDownloaded: json['downloaded_at'] != null,
      description: (json['description'] ?? '') as String,
      fileUrl: (json['file_path'] ?? json['file_url'] ?? '') as String,
    );
  }

  LessonModel copyWith({
    int? id,
    String? title,
    String? teacherName,
    String? subjectName,
    String? fileType,
    double? rating,
    int? pageCount,
    String? date,
    bool? isFavorite,
    bool? isDownloaded,
    String? description,
    String? fileUrl,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      teacherName: teacherName ?? this.teacherName,
      subjectName: subjectName ?? this.subjectName,
      fileType: fileType ?? this.fileType,
      rating: rating ?? this.rating,
      pageCount: pageCount ?? this.pageCount,
      date: date ?? this.date,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      description: description ?? this.description,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}

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

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as int,
      title: json['title'] as String,
      teacherName: json['teacher_name'] as String,
      subjectName: json['subject_name'] as String,
      fileType: json['file_type'] as String,
      rating: (json['rating'] as num).toDouble(),
      pageCount: json['page_count'] as int,
      date: json['date'] as String,
      isFavorite: json['is_favorite'] as bool,
      isDownloaded: json['is_downloaded'] as bool,
      description: json['description'] as String,
      fileUrl: json['file_url'] as String,
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

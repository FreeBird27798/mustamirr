import '../../domain/entities/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  const SubjectModel({
    required super.id,
    required super.name,
    required super.lessonCount,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as int,
      name: (json['title'] ?? json['name'] ?? '') as String,
      lessonCount: (json['lessons_count'] as num?)?.toInt() ?? 0,
    );
  }
}

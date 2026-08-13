import '../../domain/entities/admin_subject_entity.dart';

class AdminSubjectModel extends AdminSubjectEntity {
  const AdminSubjectModel({
    required super.id,
    required super.name,
    required super.grade,
    required super.lessonsCount,
  });

  factory AdminSubjectModel.fromJson(Map<String, dynamic> json) {
    return AdminSubjectModel(
      id: json['id'] as int,
      name: json['name'] as String,
      grade: json['grade'] as String,
      lessonsCount: json['lessons_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'grade': grade, 'lessons_count': lessonsCount};
  }
}

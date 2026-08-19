import '../../domain/entities/teacher_student_entity.dart';

class TeacherStudentModel extends TeacherStudentEntity {
  const TeacherStudentModel({
    required super.id,
    required super.name,
    required super.grade,
  });

  factory TeacherStudentModel.fromJson(Map<String, dynamic> json) {
    return TeacherStudentModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '') as String,
      grade:
          (json['grade'] ??
                  json['academic_level_name'] ??
                  json['track_title'] ??
                  '')
              as String,
    );
  }
}

import '../../domain/entities/teacher_affiliation.dart';

class SubjectOptionModel extends SubjectOptionEntity {
  const SubjectOptionModel({required super.id, required super.name});

  factory SubjectOptionModel.fromJson(Map<String, dynamic> json) {
    return SubjectOptionModel(
      id: (json['id'] as num).toInt(),
      // `/teacher/subjects` returns the subject name under `title`.
      name: (json['title'] ?? json['name'] ?? '') as String,
    );
  }
}

class TeacherAffiliationStatusModel extends TeacherAffiliationStatusEntity {
  const TeacherAffiliationStatusModel({
    required super.requestId,
    required super.status,
    required super.institutionName,
    required super.institutionType,
    required super.specializationName,
    required super.academicLevels,
    required super.subjects,
    super.adminNote,
  });

  factory TeacherAffiliationStatusModel.fromJson(Map<String, dynamic> json) {
    return TeacherAffiliationStatusModel(
      requestId: (json['request_id'] as num?)?.toInt(),
      status: (json['status'] ?? '') as String,
      institutionName: (json['institution_name'] ?? '') as String,
      institutionType: (json['institution_type'] ?? '') as String,
      specializationName: (json['specialization_name'] ?? '') as String,
      academicLevels: (json['academic_levels'] ?? '') as String,
      subjects: (json['subjects'] ?? '') as String,
      adminNote: json['admin_note'] as String?,
    );
  }
}

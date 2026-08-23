import 'package:equatable/equatable.dart';

/// A subject the teacher can pick to teach (from `/teacher/subjects`).
class SubjectOptionEntity extends Equatable {
  final int id;
  final String name;

  const SubjectOptionEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

/// The teacher's current affiliation request, if any. Unlike the student's, a
/// teacher affiliates with several academic levels and several subjects at once,
/// so the backend returns them as ready-made comma-joined strings.
class TeacherAffiliationStatusEntity extends Equatable {
  final int? requestId;
  final String status; // "pending" | "approved" | "rejected"
  final String institutionName;
  final String institutionType;
  final String specializationName;
  final String academicLevels; // e.g. "بكالوريوس, دبلوم"
  final String subjects; // e.g. "الرياضيات, الفيزياء"
  final String? adminNote;

  const TeacherAffiliationStatusEntity({
    required this.requestId,
    required this.status,
    required this.institutionName,
    required this.institutionType,
    required this.specializationName,
    required this.academicLevels,
    required this.subjects,
    this.adminNote,
  });

  @override
  List<Object?> get props => [
    requestId,
    status,
    institutionName,
    institutionType,
    specializationName,
    academicLevels,
    subjects,
    adminNote,
  ];
}

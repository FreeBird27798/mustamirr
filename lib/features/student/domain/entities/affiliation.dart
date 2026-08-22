import 'package:equatable/equatable.dart';

/// A kind of institution the student can affiliate with (school / university).
class InstitutionTypeEntity extends Equatable {
  final String value; // "school" | "university"
  final String label; // Arabic label

  const InstitutionTypeEntity({required this.value, required this.label});

  @override
  List<Object?> get props => [value, label];
}

class InstitutionEntity extends Equatable {
  final int id;
  final String name;
  final String type;

  const InstitutionEntity({
    required this.id,
    required this.name,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, type];
}

class AcademicLevelEntity extends Equatable {
  final int id;
  final String name;

  const AcademicLevelEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class SpecializationEntity extends Equatable {
  final int id;
  final String name;

  const SpecializationEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

/// The student's current affiliation request, if any.
class AffiliationStatusEntity extends Equatable {
  final int? requestId;
  final String status; // "pending" | "approved" | "rejected"
  final String institutionName;
  final String institutionType;
  final String academicLevelName;
  final String specializationName;

  const AffiliationStatusEntity({
    required this.requestId,
    required this.status,
    required this.institutionName,
    required this.institutionType,
    required this.academicLevelName,
    required this.specializationName,
  });

  @override
  List<Object?> get props => [
    requestId,
    status,
    institutionName,
    institutionType,
    academicLevelName,
    specializationName,
  ];
}

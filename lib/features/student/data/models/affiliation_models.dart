import '../../domain/entities/affiliation.dart';

class InstitutionTypeModel extends InstitutionTypeEntity {
  const InstitutionTypeModel({required super.value, required super.label});

  factory InstitutionTypeModel.fromJson(Map<String, dynamic> json) {
    return InstitutionTypeModel(
      value: (json['value'] ?? '') as String,
      label: (json['label'] ?? '') as String,
    );
  }
}

class InstitutionModel extends InstitutionEntity {
  const InstitutionModel({
    required super.id,
    required super.name,
    required super.type,
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? '') as String,
      type: (json['type'] ?? '') as String,
    );
  }
}

class AcademicLevelModel extends AcademicLevelEntity {
  const AcademicLevelModel({required super.id, required super.name});

  factory AcademicLevelModel.fromJson(Map<String, dynamic> json) {
    return AcademicLevelModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? '') as String,
    );
  }
}

class SpecializationModel extends SpecializationEntity {
  const SpecializationModel({required super.id, required super.name});

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? '') as String,
    );
  }
}

class AffiliationStatusModel extends AffiliationStatusEntity {
  const AffiliationStatusModel({
    required super.requestId,
    required super.status,
    required super.institutionName,
    required super.institutionType,
    required super.academicLevelName,
    required super.specializationName,
  });

  factory AffiliationStatusModel.fromJson(Map<String, dynamic> json) {
    return AffiliationStatusModel(
      requestId: (json['request_id'] as num?)?.toInt(),
      status: (json['status'] ?? '') as String,
      institutionName: (json['institution_name'] ?? '') as String,
      institutionType: (json['institution_type'] ?? '') as String,
      academicLevelName: (json['academic_level_name'] ?? '') as String,
      specializationName: (json['specialization_name'] ?? '') as String,
    );
  }
}

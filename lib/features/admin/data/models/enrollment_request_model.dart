import '../../domain/entities/enrollment_request_entity.dart';

class EnrollmentRequestModel extends EnrollmentRequestEntity {
  const EnrollmentRequestModel({
    required super.id,
    required super.name,
    required super.role,
    required super.affiliation,
    required super.status,
    required super.createdAt,
  });

  factory EnrollmentRequestModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentRequestModel(
      id: json['id'] as int,
      name: json['name'] as String,
      role: json['role'] as String,
      affiliation: json['affiliation'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  EnrollmentRequestModel copyWith({String? status}) {
    return EnrollmentRequestModel(
      id: id,
      name: name,
      role: role,
      affiliation: affiliation,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

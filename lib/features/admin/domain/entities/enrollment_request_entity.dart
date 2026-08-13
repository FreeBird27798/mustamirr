import 'package:equatable/equatable.dart';

class EnrollmentRequestEntity extends Equatable {
  final int id;
  final String name;
  final String role; // student, teacher
  final String affiliation; // e.g. "مدرسة النور - الصف الثالث الثانوي"
  final String status; // pending, approved
  final String createdAt;

  const EnrollmentRequestEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.affiliation,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, role, affiliation, status, createdAt];
}

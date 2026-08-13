import 'package:equatable/equatable.dart';

class AdminUserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String role; // student, teacher
  final bool isActive;
  final String affiliation; // e.g. "مدرسة النور - الصف الثالث الثانوي"

  const AdminUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.affiliation,
  });

  @override
  List<Object?> get props => [id, name, email, role, isActive, affiliation];
}

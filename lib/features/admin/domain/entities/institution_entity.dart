import 'package:equatable/equatable.dart';

/// One item in the "institutions" management screen. `type` selects which
/// tab it belongs to: university, school, specialization, grade.
/// `subtitle` holds the secondary line (city, or parent + degree, etc.).
class InstitutionEntity extends Equatable {
  final int id;
  final String type; // university, school, specialization, grade
  final String name;
  final String subtitle;

  const InstitutionEntity({
    required this.id,
    required this.type,
    required this.name,
    required this.subtitle,
  });

  @override
  List<Object?> get props => [id, type, name, subtitle];
}

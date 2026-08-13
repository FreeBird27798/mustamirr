import 'package:equatable/equatable.dart';

class AdminSubjectEntity extends Equatable {
  final int id;
  final String name;
  final String grade;
  final int lessonsCount;

  const AdminSubjectEntity({
    required this.id,
    required this.name,
    required this.grade,
    required this.lessonsCount,
  });

  @override
  List<Object?> get props => [id, name, grade, lessonsCount];
}

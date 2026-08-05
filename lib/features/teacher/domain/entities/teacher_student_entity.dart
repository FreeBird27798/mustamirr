import 'package:equatable/equatable.dart';

class TeacherStudentEntity extends Equatable {
  final int id;
  final String name;
  final String grade;

  const TeacherStudentEntity({
    required this.id,
    required this.name,
    required this.grade,
  });

  @override
  List<Object?> get props => [id, name, grade];
}

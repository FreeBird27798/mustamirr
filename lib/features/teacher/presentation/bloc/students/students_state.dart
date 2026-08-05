import 'package:equatable/equatable.dart';

import '../../../domain/entities/teacher_student_entity.dart';

abstract class StudentsState extends Equatable {
  const StudentsState();

  @override
  List<Object?> get props => [];
}

class StudentsInitial extends StudentsState {}

class StudentsLoading extends StudentsState {}

class StudentsLoaded extends StudentsState {
  final List<TeacherStudentEntity> students;
  const StudentsLoaded({required this.students});

  @override
  List<Object?> get props => [students];
}

class StudentsError extends StudentsState {
  final String message;
  const StudentsError({required this.message});

  @override
  List<Object?> get props => [message];
}

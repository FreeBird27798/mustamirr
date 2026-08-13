import 'package:equatable/equatable.dart';

import '../../../domain/entities/admin_subject_entity.dart';

abstract class AdminSubjectsState extends Equatable {
  const AdminSubjectsState();

  @override
  List<Object?> get props => [];
}

class AdminSubjectsInitial extends AdminSubjectsState {}

class AdminSubjectsLoading extends AdminSubjectsState {}

class AdminSubjectsLoaded extends AdminSubjectsState {
  final List<AdminSubjectEntity> subjects;
  const AdminSubjectsLoaded({required this.subjects});

  @override
  List<Object?> get props => [subjects];
}

class AdminSubjectsError extends AdminSubjectsState {
  final String message;
  const AdminSubjectsError({required this.message});

  @override
  List<Object?> get props => [message];
}

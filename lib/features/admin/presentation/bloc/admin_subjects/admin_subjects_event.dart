import 'package:equatable/equatable.dart';

import '../../../domain/entities/admin_subject_entity.dart';

abstract class AdminSubjectsEvent extends Equatable {
  const AdminSubjectsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSubjectsEvent extends AdminSubjectsEvent {}

class AddSubjectEvent extends AdminSubjectsEvent {
  final AdminSubjectEntity subject;
  const AddSubjectEvent({required this.subject});

  @override
  List<Object?> get props => [subject];
}

class DeleteSubjectEvent extends AdminSubjectsEvent {
  final int subjectId;
  const DeleteSubjectEvent({required this.subjectId});

  @override
  List<Object?> get props => [subjectId];
}

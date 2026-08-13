import 'package:equatable/equatable.dart';

import '../../../domain/entities/institution_entity.dart';

abstract class InstitutionsEvent extends Equatable {
  const InstitutionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadInstitutionsEvent extends InstitutionsEvent {
  final String type;
  const LoadInstitutionsEvent({required this.type});

  @override
  List<Object?> get props => [type];
}

class AddInstitutionEvent extends InstitutionsEvent {
  final InstitutionEntity institution;
  const AddInstitutionEvent({required this.institution});

  @override
  List<Object?> get props => [institution];
}

class DeleteInstitutionEvent extends InstitutionsEvent {
  final int institutionId;
  const DeleteInstitutionEvent({required this.institutionId});

  @override
  List<Object?> get props => [institutionId];
}

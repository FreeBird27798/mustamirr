import 'package:equatable/equatable.dart';

import '../../../domain/entities/institution_entity.dart';

abstract class InstitutionsState extends Equatable {
  const InstitutionsState();

  @override
  List<Object?> get props => [];
}

class InstitutionsInitial extends InstitutionsState {}

class InstitutionsLoading extends InstitutionsState {}

class InstitutionsLoaded extends InstitutionsState {
  final List<InstitutionEntity> institutions;
  const InstitutionsLoaded({required this.institutions});

  @override
  List<Object?> get props => [institutions];
}

class InstitutionsError extends InstitutionsState {
  final String message;
  const InstitutionsError({required this.message});

  @override
  List<Object?> get props => [message];
}

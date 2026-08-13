import 'package:equatable/equatable.dart';

import '../../../domain/entities/enrollment_request_entity.dart';

abstract class EnrollmentState extends Equatable {
  const EnrollmentState();

  @override
  List<Object?> get props => [];
}

class EnrollmentInitial extends EnrollmentState {}

class EnrollmentLoading extends EnrollmentState {}

class EnrollmentLoaded extends EnrollmentState {
  final List<EnrollmentRequestEntity> requests;
  const EnrollmentLoaded({required this.requests});

  List<EnrollmentRequestEntity> get students =>
      requests.where((r) => r.role == 'student').toList();
  List<EnrollmentRequestEntity> get teachers =>
      requests.where((r) => r.role == 'teacher').toList();

  @override
  List<Object?> get props => [requests];
}

class EnrollmentError extends EnrollmentState {
  final String message;
  const EnrollmentError({required this.message});

  @override
  List<Object?> get props => [message];
}

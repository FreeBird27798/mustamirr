import 'package:equatable/equatable.dart';

abstract class EnrollmentEvent extends Equatable {
  const EnrollmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadRequestsEvent extends EnrollmentEvent {}

class ApproveRequestEvent extends EnrollmentEvent {
  final int requestId;
  const ApproveRequestEvent({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

class RejectRequestEvent extends EnrollmentEvent {
  final int requestId;
  const RejectRequestEvent({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

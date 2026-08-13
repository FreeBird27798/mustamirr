import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/approve_request_usecase.dart';
import '../../../domain/usecases/get_enrollment_requests_usecase.dart';
import '../../../domain/usecases/reject_request_usecase.dart';
import 'enrollment_event.dart';
import 'enrollment_state.dart';

class EnrollmentBloc extends Bloc<EnrollmentEvent, EnrollmentState> {
  final GetEnrollmentRequestsUseCase getEnrollmentRequestsUseCase;
  final ApproveRequestUseCase approveRequestUseCase;
  final RejectRequestUseCase rejectRequestUseCase;

  EnrollmentBloc({
    required this.getEnrollmentRequestsUseCase,
    required this.approveRequestUseCase,
    required this.rejectRequestUseCase,
  }) : super(EnrollmentInitial()) {
    on<LoadRequestsEvent>(_onLoad);
    on<ApproveRequestEvent>(_onApprove);
    on<RejectRequestEvent>(_onReject);
  }

  Future<void> _onLoad(
    LoadRequestsEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(EnrollmentLoading());
    await _fetchAndEmit(emit);
  }

  Future<void> _onApprove(
    ApproveRequestEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    final result = await approveRequestUseCase(event.requestId);
    await result.fold(
      (failure) async => emit(EnrollmentError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _onReject(
    RejectRequestEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    final result = await rejectRequestUseCase(event.requestId);
    await result.fold(
      (failure) async => emit(EnrollmentError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _fetchAndEmit(Emitter<EnrollmentState> emit) async {
    final result = await getEnrollmentRequestsUseCase(NoParams());
    result.fold(
      (failure) => emit(EnrollmentError(message: failure.message)),
      (requests) => emit(EnrollmentLoaded(requests: requests)),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/add_subject_usecase.dart';
import '../../../domain/usecases/delete_subject_usecase.dart';
import '../../../domain/usecases/get_admin_subjects_usecase.dart';
import 'admin_subjects_event.dart';
import 'admin_subjects_state.dart';

class AdminSubjectsBloc extends Bloc<AdminSubjectsEvent, AdminSubjectsState> {
  final GetAdminSubjectsUseCase getAdminSubjectsUseCase;
  final AddSubjectUseCase addSubjectUseCase;
  final DeleteSubjectUseCase deleteSubjectUseCase;

  AdminSubjectsBloc({
    required this.getAdminSubjectsUseCase,
    required this.addSubjectUseCase,
    required this.deleteSubjectUseCase,
  }) : super(AdminSubjectsInitial()) {
    on<LoadSubjectsEvent>(_onLoad);
    on<AddSubjectEvent>(_onAdd);
    on<DeleteSubjectEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadSubjectsEvent event,
    Emitter<AdminSubjectsState> emit,
  ) async {
    emit(AdminSubjectsLoading());
    await _fetchAndEmit(emit);
  }

  Future<void> _onAdd(
    AddSubjectEvent event,
    Emitter<AdminSubjectsState> emit,
  ) async {
    final result = await addSubjectUseCase(event.subject);
    await result.fold(
      (failure) async => emit(AdminSubjectsError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _onDelete(
    DeleteSubjectEvent event,
    Emitter<AdminSubjectsState> emit,
  ) async {
    final result = await deleteSubjectUseCase(event.subjectId);
    await result.fold(
      (failure) async => emit(AdminSubjectsError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _fetchAndEmit(Emitter<AdminSubjectsState> emit) async {
    final result = await getAdminSubjectsUseCase(NoParams());
    result.fold(
      (failure) => emit(AdminSubjectsError(message: failure.message)),
      (subjects) => emit(AdminSubjectsLoaded(subjects: subjects)),
    );
  }
}

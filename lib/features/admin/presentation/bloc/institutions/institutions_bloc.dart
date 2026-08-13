import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/add_institution_usecase.dart';
import '../../../domain/usecases/delete_institution_usecase.dart';
import '../../../domain/usecases/get_institutions_usecase.dart';
import 'institutions_event.dart';
import 'institutions_state.dart';

class InstitutionsBloc extends Bloc<InstitutionsEvent, InstitutionsState> {
  final GetInstitutionsUseCase getInstitutionsUseCase;
  final AddInstitutionUseCase addInstitutionUseCase;
  final DeleteInstitutionUseCase deleteInstitutionUseCase;

  // Remembers which tab (type) is loaded so mutations reload the same one.
  String _currentType = 'university';

  InstitutionsBloc({
    required this.getInstitutionsUseCase,
    required this.addInstitutionUseCase,
    required this.deleteInstitutionUseCase,
  }) : super(InstitutionsInitial()) {
    on<LoadInstitutionsEvent>(_onLoad);
    on<AddInstitutionEvent>(_onAdd);
    on<DeleteInstitutionEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadInstitutionsEvent event,
    Emitter<InstitutionsState> emit,
  ) async {
    _currentType = event.type;
    emit(InstitutionsLoading());
    await _fetchAndEmit(emit);
  }

  Future<void> _onAdd(
    AddInstitutionEvent event,
    Emitter<InstitutionsState> emit,
  ) async {
    final result = await addInstitutionUseCase(event.institution);
    await result.fold(
      (failure) async => emit(InstitutionsError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _onDelete(
    DeleteInstitutionEvent event,
    Emitter<InstitutionsState> emit,
  ) async {
    final result = await deleteInstitutionUseCase(event.institutionId);
    await result.fold(
      (failure) async => emit(InstitutionsError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _fetchAndEmit(Emitter<InstitutionsState> emit) async {
    final result = await getInstitutionsUseCase(_currentType);
    result.fold(
      (failure) => emit(InstitutionsError(message: failure.message)),
      (institutions) => emit(InstitutionsLoaded(institutions: institutions)),
    );
  }
}

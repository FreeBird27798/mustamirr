import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/affiliation.dart';
import '../../domain/repositories/student_repository.dart';

class AffiliationState extends Equatable {
  final bool initialLoading; // checking existing status / loading types
  final AffiliationStatusEntity? existingStatus; // non-null → show status view
  final List<InstitutionTypeEntity> types;
  final List<InstitutionEntity> institutions;
  final List<AcademicLevelEntity> levels;
  final List<SpecializationEntity> specializations;
  final String? selectedType;
  final int? selectedInstitutionId;
  final int? selectedLevelId;
  final int? selectedSpecializationId;
  final bool stepLoading; // loading a cascade list
  final bool submitting;
  final bool submitted;
  final String? error;

  const AffiliationState({
    this.initialLoading = true,
    this.existingStatus,
    this.types = const [],
    this.institutions = const [],
    this.levels = const [],
    this.specializations = const [],
    this.selectedType,
    this.selectedInstitutionId,
    this.selectedLevelId,
    this.selectedSpecializationId,
    this.stepLoading = false,
    this.submitting = false,
    this.submitted = false,
    this.error,
  });

  bool get canSubmit =>
      selectedType != null &&
      selectedInstitutionId != null &&
      selectedLevelId != null &&
      selectedSpecializationId != null;

  @override
  List<Object?> get props => [
    initialLoading,
    existingStatus,
    types,
    institutions,
    levels,
    specializations,
    selectedType,
    selectedInstitutionId,
    selectedLevelId,
    selectedSpecializationId,
    stepLoading,
    submitting,
    submitted,
    error,
  ];
}

class AffiliationCubit extends Cubit<AffiliationState> {
  final StudentRepository repository;

  AffiliationCubit(this.repository) : super(const AffiliationState());

  Future<void> init() async {
    emit(const AffiliationState(initialLoading: true));
    // If a request already exists, show its status instead of the form.
    final statusResult = await repository.getAffiliationStatus();
    final existing = statusResult.fold((_) => null, (s) => s);
    if (existing != null) {
      emit(AffiliationState(initialLoading: false, existingStatus: existing));
      return;
    }
    final typesResult = await repository.getInstitutionTypes();
    typesResult.fold(
      (f) => emit(AffiliationState(initialLoading: false, error: f.message)),
      (types) => emit(AffiliationState(initialLoading: false, types: types)),
    );
  }

  Future<void> selectType(String type) async {
    emit(
      AffiliationState(
        initialLoading: false,
        types: state.types,
        selectedType: type,
        stepLoading: true,
      ),
    );
    final result = await repository.getInstitutions(type);
    result.fold(
      (f) => emit(_base().copyError(f.message)),
      (list) => emit(_base(institutions: list)),
    );
  }

  Future<void> selectInstitution(int id) async {
    emit(
      AffiliationState(
        initialLoading: false,
        types: state.types,
        institutions: state.institutions,
        selectedType: state.selectedType,
        selectedInstitutionId: id,
        stepLoading: true,
      ),
    );
    final result = await repository.getLevels(id);
    result.fold(
      (f) => emit(_baseInst().copyError(f.message)),
      (list) => emit(_baseInst(levels: list)),
    );
  }

  Future<void> selectLevel(int id) async {
    emit(
      AffiliationState(
        initialLoading: false,
        types: state.types,
        institutions: state.institutions,
        levels: state.levels,
        selectedType: state.selectedType,
        selectedInstitutionId: state.selectedInstitutionId,
        selectedLevelId: id,
        stepLoading: true,
      ),
    );
    final result = await repository.getSpecializations(id);
    result.fold(
      (f) => emit(_baseLevel().copyError(f.message)),
      (list) => emit(_baseLevel(specializations: list)),
    );
  }

  void selectSpecialization(int id) {
    emit(
      AffiliationState(
        initialLoading: false,
        types: state.types,
        institutions: state.institutions,
        levels: state.levels,
        specializations: state.specializations,
        selectedType: state.selectedType,
        selectedInstitutionId: state.selectedInstitutionId,
        selectedLevelId: state.selectedLevelId,
        selectedSpecializationId: id,
      ),
    );
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(_full(submitting: true));
    final result = await repository.submitAffiliation(
      institutionType: state.selectedType!,
      institutionId: state.selectedInstitutionId!,
      academicLevelId: state.selectedLevelId!,
      specializationId: state.selectedSpecializationId!,
    );
    result.fold(
      (f) => emit(_full(error: f.message)),
      (_) => emit(_full(submitted: true)),
    );
  }

  // ---- state builders that preserve selections/lists ----

  AffiliationState _base({List<InstitutionEntity>? institutions}) =>
      AffiliationState(
        initialLoading: false,
        types: state.types,
        institutions: institutions ?? const [],
        selectedType: state.selectedType,
      );

  AffiliationState _baseInst({List<AcademicLevelEntity>? levels}) =>
      AffiliationState(
        initialLoading: false,
        types: state.types,
        institutions: state.institutions,
        levels: levels ?? const [],
        selectedType: state.selectedType,
        selectedInstitutionId: state.selectedInstitutionId,
      );

  AffiliationState _baseLevel({List<SpecializationEntity>? specializations}) =>
      AffiliationState(
        initialLoading: false,
        types: state.types,
        institutions: state.institutions,
        levels: state.levels,
        specializations: specializations ?? const [],
        selectedType: state.selectedType,
        selectedInstitutionId: state.selectedInstitutionId,
        selectedLevelId: state.selectedLevelId,
      );

  AffiliationState _full({
    bool submitting = false,
    bool submitted = false,
    String? error,
  }) => AffiliationState(
    initialLoading: false,
    types: state.types,
    institutions: state.institutions,
    levels: state.levels,
    specializations: state.specializations,
    selectedType: state.selectedType,
    selectedInstitutionId: state.selectedInstitutionId,
    selectedLevelId: state.selectedLevelId,
    selectedSpecializationId: state.selectedSpecializationId,
    submitting: submitting,
    submitted: submitted,
    error: error,
  );
}

extension on AffiliationState {
  AffiliationState copyError(String message) => AffiliationState(
    initialLoading: false,
    types: types,
    institutions: institutions,
    levels: levels,
    specializations: specializations,
    selectedType: selectedType,
    selectedInstitutionId: selectedInstitutionId,
    selectedLevelId: selectedLevelId,
    selectedSpecializationId: selectedSpecializationId,
    error: message,
  );
}

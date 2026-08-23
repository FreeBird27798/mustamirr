import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../student/domain/entities/affiliation.dart';
import '../../domain/entities/teacher_affiliation.dart';
import '../../domain/repositories/teacher_repository.dart';

/// Sentinel so [TeacherAffiliationState.copyWith] can tell "leave unchanged"
/// apart from "set to null" for the nullable fields.
const Object _unset = Object();

class TeacherAffiliationState extends Equatable {
  final bool initialLoading;
  final TeacherAffiliationStatusEntity? existingStatus; // non-null → status view

  final List<InstitutionTypeEntity> types;
  final List<InstitutionEntity> institutions;
  final List<AcademicLevelEntity> levels;
  final List<SpecializationEntity> specializations;
  final List<SubjectOptionEntity> subjects;

  final String? selectedType;
  final int? selectedInstitutionId;
  final Set<int> selectedLevelIds;
  final Set<int> selectedSubjectIds;
  final int? selectedSpecializationId;

  /// The academic level whose specializations are currently loaded.
  final int? specLevelId;

  final bool stepLoading; // loading institutions / levels
  final bool specLoading; // loading specializations
  final bool submitting;
  final bool submitted;
  final String? error;

  const TeacherAffiliationState({
    this.initialLoading = true,
    this.existingStatus,
    this.types = const [],
    this.institutions = const [],
    this.levels = const [],
    this.specializations = const [],
    this.subjects = const [],
    this.selectedType,
    this.selectedInstitutionId,
    this.selectedLevelIds = const {},
    this.selectedSubjectIds = const {},
    this.selectedSpecializationId,
    this.specLevelId,
    this.stepLoading = false,
    this.specLoading = false,
    this.submitting = false,
    this.submitted = false,
    this.error,
  });

  bool get canSubmit =>
      selectedType != null &&
      selectedInstitutionId != null &&
      selectedLevelIds.isNotEmpty &&
      selectedSubjectIds.isNotEmpty &&
      selectedSpecializationId != null;

  TeacherAffiliationState copyWith({
    bool? initialLoading,
    Object? existingStatus = _unset,
    List<InstitutionTypeEntity>? types,
    List<InstitutionEntity>? institutions,
    List<AcademicLevelEntity>? levels,
    List<SpecializationEntity>? specializations,
    List<SubjectOptionEntity>? subjects,
    Object? selectedType = _unset,
    Object? selectedInstitutionId = _unset,
    Set<int>? selectedLevelIds,
    Set<int>? selectedSubjectIds,
    Object? selectedSpecializationId = _unset,
    Object? specLevelId = _unset,
    bool? stepLoading,
    bool? specLoading,
    bool? submitting,
    bool? submitted,
    Object? error = _unset,
  }) {
    return TeacherAffiliationState(
      initialLoading: initialLoading ?? this.initialLoading,
      existingStatus: existingStatus == _unset
          ? this.existingStatus
          : existingStatus as TeacherAffiliationStatusEntity?,
      types: types ?? this.types,
      institutions: institutions ?? this.institutions,
      levels: levels ?? this.levels,
      specializations: specializations ?? this.specializations,
      subjects: subjects ?? this.subjects,
      selectedType: selectedType == _unset
          ? this.selectedType
          : selectedType as String?,
      selectedInstitutionId: selectedInstitutionId == _unset
          ? this.selectedInstitutionId
          : selectedInstitutionId as int?,
      selectedLevelIds: selectedLevelIds ?? this.selectedLevelIds,
      selectedSubjectIds: selectedSubjectIds ?? this.selectedSubjectIds,
      selectedSpecializationId: selectedSpecializationId == _unset
          ? this.selectedSpecializationId
          : selectedSpecializationId as int?,
      specLevelId: specLevelId == _unset
          ? this.specLevelId
          : specLevelId as int?,
      stepLoading: stepLoading ?? this.stepLoading,
      specLoading: specLoading ?? this.specLoading,
      submitting: submitting ?? this.submitting,
      submitted: submitted ?? this.submitted,
      error: error == _unset ? this.error : error as String?,
    );
  }

  @override
  List<Object?> get props => [
    initialLoading,
    existingStatus,
    types,
    institutions,
    levels,
    specializations,
    subjects,
    selectedType,
    selectedInstitutionId,
    selectedLevelIds,
    selectedSubjectIds,
    selectedSpecializationId,
    specLevelId,
    stepLoading,
    specLoading,
    submitting,
    submitted,
    error,
  ];
}

class TeacherAffiliationCubit extends Cubit<TeacherAffiliationState> {
  final TeacherRepository repository;

  TeacherAffiliationCubit(this.repository)
    : super(const TeacherAffiliationState());

  Future<void> init() async {
    emit(const TeacherAffiliationState(initialLoading: true));

    // If a request already exists, show its status instead of the form.
    final statusResult = await repository.getTeacherAffiliationStatus();
    final existing = statusResult.fold((_) => null, (s) => s);
    if (existing != null) {
      emit(
        TeacherAffiliationState(initialLoading: false, existingStatus: existing),
      );
      return;
    }

    // Load the institution types and the (flat) subject list together.
    final typesResult = await repository.getInstitutionTypes();
    final subjectsResult = await repository.getSubjectOptions();
    final types = typesResult.fold((_) => <InstitutionTypeEntity>[], (t) => t);
    final subjects = subjectsResult.fold((_) => <SubjectOptionEntity>[], (s) => s);
    final failure = typesResult.fold((f) => f.message, (_) => null);

    emit(
      TeacherAffiliationState(
        initialLoading: false,
        types: types,
        subjects: subjects,
        error: failure,
      ),
    );
  }

  Future<void> selectType(String type) async {
    emit(
      state.copyWith(
        selectedType: type,
        selectedInstitutionId: null,
        institutions: const [],
        levels: const [],
        specializations: const [],
        selectedLevelIds: <int>{},
        selectedSpecializationId: null,
        specLevelId: null,
        stepLoading: true,
        error: null,
      ),
    );
    final result = await repository.getInstitutions(type);
    result.fold(
      (f) => emit(state.copyWith(stepLoading: false, error: f.message)),
      (list) => emit(state.copyWith(stepLoading: false, institutions: list)),
    );
  }

  Future<void> selectInstitution(int id) async {
    emit(
      state.copyWith(
        selectedInstitutionId: id,
        levels: const [],
        specializations: const [],
        selectedLevelIds: <int>{},
        selectedSpecializationId: null,
        specLevelId: null,
        stepLoading: true,
        error: null,
      ),
    );
    final result = await repository.getLevels(id);
    result.fold(
      (f) => emit(state.copyWith(stepLoading: false, error: f.message)),
      (list) => emit(state.copyWith(stepLoading: false, levels: list)),
    );
  }

  /// Teachers pick several academic levels. Specializations belong to a level,
  /// so we load them for the first-picked level and keep that stable.
  Future<void> toggleLevel(int id) async {
    final newSet = Set<int>.from(state.selectedLevelIds);
    newSet.contains(id) ? newSet.remove(id) : newSet.add(id);

    if (newSet.isEmpty) {
      emit(
        state.copyWith(
          selectedLevelIds: newSet,
          specializations: const [],
          selectedSpecializationId: null,
          specLevelId: null,
        ),
      );
      return;
    }

    final primary = newSet.first;
    if (primary == state.specLevelId) {
      // Same source level → specializations list is still valid.
      emit(state.copyWith(selectedLevelIds: newSet));
      return;
    }

    emit(
      state.copyWith(
        selectedLevelIds: newSet,
        specLoading: true,
        selectedSpecializationId: null,
      ),
    );
    final result = await repository.getSpecializations(primary);
    result.fold(
      (f) => emit(state.copyWith(specLoading: false, error: f.message)),
      (list) => emit(
        state.copyWith(
          specLoading: false,
          specializations: list,
          specLevelId: primary,
        ),
      ),
    );
  }

  void toggleSubject(int id) {
    final newSet = Set<int>.from(state.selectedSubjectIds);
    newSet.contains(id) ? newSet.remove(id) : newSet.add(id);
    emit(state.copyWith(selectedSubjectIds: newSet));
  }

  void selectSpecialization(int id) {
    emit(state.copyWith(selectedSpecializationId: id));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(submitting: true, error: null));
    final result = await repository.submitTeacherAffiliation(
      institutionType: state.selectedType!,
      institutionId: state.selectedInstitutionId!,
      academicLevelIds: state.selectedLevelIds.toList(),
      subjectIds: state.selectedSubjectIds.toList(),
      specializationId: state.selectedSpecializationId!,
    );
    result.fold(
      (f) => emit(state.copyWith(submitting: false, error: f.message)),
      (_) => emit(state.copyWith(submitting: false, submitted: true)),
    );
  }
}

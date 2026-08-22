import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_subjects_usecase.dart';
import 'subjects_event.dart';
import 'subjects_state.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  final GetSubjectsUseCase getSubjectsUseCase;

  SubjectsBloc({required this.getSubjectsUseCase}) : super(SubjectsInitial()) {
    on<LoadSubjectsEvent>(_onLoadSubjects);
  }

  Future<void> _onLoadSubjects(
    LoadSubjectsEvent event,
    Emitter<SubjectsState> emit,
  ) async {
    emit(SubjectsLoading());
    final result = await getSubjectsUseCase(NoParams());
    result.fold(
      (failure) => emit(SubjectsError(message: failure.message)),
      (subjects) => emit(SubjectsLoaded(subjects: subjects)),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_my_students_usecase.dart';
import 'students_event.dart';
import 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final GetMyStudentsUseCase getMyStudentsUseCase;

  StudentsBloc({required this.getMyStudentsUseCase})
    : super(StudentsInitial()) {
    on<LoadStudentsEvent>(_onLoadStudents);
  }

  Future<void> _onLoadStudents(
    LoadStudentsEvent event,
    Emitter<StudentsState> emit,
  ) async {
    emit(StudentsLoading());
    final result = await getMyStudentsUseCase(NoParams());
    result.fold(
      (failure) => emit(StudentsError(message: failure.message)),
      (students) => emit(StudentsLoaded(students: students)),
    );
  }
}

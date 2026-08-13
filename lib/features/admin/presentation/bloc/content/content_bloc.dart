import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/delete_content_usecase.dart';
import '../../../domain/usecases/get_content_usecase.dart';
import 'content_event.dart';
import 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final GetContentUseCase getContentUseCase;
  final DeleteContentUseCase deleteContentUseCase;

  ContentBloc({
    required this.getContentUseCase,
    required this.deleteContentUseCase,
  }) : super(ContentInitial()) {
    on<LoadContentEvent>(_onLoad);
    on<DeleteContentEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadContentEvent event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());
    await _fetchAndEmit(emit);
  }

  Future<void> _onDelete(
    DeleteContentEvent event,
    Emitter<ContentState> emit,
  ) async {
    final result = await deleteContentUseCase(event.contentId);
    await result.fold(
      (failure) async => emit(ContentError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _fetchAndEmit(Emitter<ContentState> emit) async {
    final result = await getContentUseCase(NoParams());
    result.fold(
      (failure) => emit(ContentError(message: failure.message)),
      (content) => emit(ContentLoaded(content: content)),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/delete_download_usecase.dart';
import '../../../domain/usecases/get_downloads_usecase.dart';
import 'downloads_event.dart';
import 'downloads_state.dart';

class DownloadsBloc extends Bloc<DownloadsEvent, DownloadsState> {
  final GetDownloadsUseCase getDownloadsUseCase;
  final DeleteDownloadUseCase deleteDownloadUseCase;

  DownloadsBloc({
    required this.getDownloadsUseCase,
    required this.deleteDownloadUseCase,
  }) : super(DownloadsInitial()) {
    on<LoadDownloadsEvent>(_onLoadDownloads);
    on<DeleteDownloadEvent>(_onDeleteDownload);
  }

  Future<void> _onLoadDownloads(
    LoadDownloadsEvent event,
    Emitter<DownloadsState> emit,
  ) async {
    emit(DownloadsLoading());
    final result = await getDownloadsUseCase(NoParams());
    result.fold(
      (failure) => emit(DownloadsError(message: failure.message)),
      (downloads) => emit(DownloadsLoaded(downloads: downloads)),
    );
  }

  Future<void> _onDeleteDownload(
    DeleteDownloadEvent event,
    Emitter<DownloadsState> emit,
  ) async {
    final result = await deleteDownloadUseCase(event.lessonId);
    result.fold(
      (failure) => emit(DownloadsError(message: failure.message)),
      (_) => add(LoadDownloadsEvent()),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_admin_stats_usecase.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final GetAdminStatsUseCase getAdminStatsUseCase;

  AdminDashboardBloc({required this.getAdminStatsUseCase})
    : super(AdminDashboardInitial()) {
    on<LoadAdminDashboardEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadAdminDashboardEvent event,
    Emitter<AdminDashboardState> emit,
  ) async {
    emit(AdminDashboardLoading());
    final result = await getAdminStatsUseCase(NoParams());
    result.fold(
      (failure) => emit(AdminDashboardError(message: failure.message)),
      (stats) => emit(AdminDashboardLoaded(stats: stats)),
    );
  }
}

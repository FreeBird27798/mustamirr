import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/delete_user_usecase.dart';
import '../../../domain/usecases/get_users_usecase.dart';
import '../../../domain/usecases/toggle_user_active_usecase.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsersUseCase getUsersUseCase;
  final ToggleUserActiveUseCase toggleUserActiveUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  UsersBloc({
    required this.getUsersUseCase,
    required this.toggleUserActiveUseCase,
    required this.deleteUserUseCase,
  }) : super(UsersInitial()) {
    on<LoadUsersEvent>(_onLoad);
    on<ToggleUserActiveEvent>(_onToggle);
    on<DeleteUserEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadUsersEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    await _fetchAndEmit(emit);
  }

  Future<void> _onToggle(
    ToggleUserActiveEvent event,
    Emitter<UsersState> emit,
  ) async {
    final result = await toggleUserActiveUseCase(event.userId);
    await result.fold(
      (failure) async => emit(UsersError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  Future<void> _onDelete(
    DeleteUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    final result = await deleteUserUseCase(event.userId);
    await result.fold(
      (failure) async => emit(UsersError(message: failure.message)),
      (_) async => _fetchAndEmit(emit),
    );
  }

  /// Fetches users and emits Loaded/Error without a Loading spinner —
  /// used after mutations so the list doesn't flash.
  Future<void> _fetchAndEmit(Emitter<UsersState> emit) async {
    final result = await getUsersUseCase(NoParams());
    result.fold(
      (failure) => emit(UsersError(message: failure.message)),
      (users) => emit(UsersLoaded(users: users)),
    );
  }
}

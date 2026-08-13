import 'package:equatable/equatable.dart';

import '../../../domain/entities/admin_user_entity.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<AdminUserEntity> users;
  const UsersLoaded({required this.users});

  // Convenience filters for the two tabs.
  List<AdminUserEntity> get students =>
      users.where((u) => u.role == 'student').toList();
  List<AdminUserEntity> get teachers =>
      users.where((u) => u.role == 'teacher').toList();

  @override
  List<Object?> get props => [users];
}

class UsersError extends UsersState {
  final String message;
  const UsersError({required this.message});

  @override
  List<Object?> get props => [message];
}
